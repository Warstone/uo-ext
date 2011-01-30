unit ClientThread;

interface

uses Windows, WinSock, AbstractThread, PacketStream, ProtocolDescription;

type
  TClientThread=class(TAbstractThread)
  private
    FClientConnection:TSocket;
    FServerConnection:TSocket;

    FServerIp:Cardinal;
    FServerPort:Word;

    FLocalPort:Word;

    FCSObj:TPacketStream;
    FSCObj:TPacketStream;
    function ConnectToServer:Boolean;
    procedure Write(What:String);
    procedure OnCSPacket(Sender:TObject; Packet:Pointer; var Length:Cardinal; var Process:Boolean);
    procedure OnSCPacket(Sender:TObject; Packet:Pointer; var Length:Cardinal; var Process:Boolean);
  protected
    function Execute:Integer; override;
  public
    property ServerIP:Cardinal read FServerIp write FServerIp;
    property ServerPort:Word read FServerPort write FServerPort;
    property LocalPort:Word read FLocalPort write FLocalPort;
    property ClientSocket:TSocket read FClientConnection write FClientConnection;
    function SendPacket(Packet: Pointer; Length: Cardinal; ToServer, Direct: Boolean; var Valid: Boolean):Boolean;
  end;

var
  CurrentClientThread: TClientThread;

implementation

uses Common, Plugins;
//uses SysUtils;

var
  TV_Timeout:timeval;

procedure TClientThread.Write(What:String);
begin
  {$IFDEF DEBUG}
  WriteLn(FServerIp shr 24, '.', (FServerIp shr 16) and $FF, '.', (FServerIp shr 8) and $FF, '.', FServerIp and $FF, ':', FServerPort, ' ', What);
  {$ENDIF}
end;

function TClientThread.ConnectToServer:Boolean;
var
  SockAddr:TSockAddr;
begin
  Result:=False;
  FServerConnection:=socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
  IF FServerConnection=INVALID_SOCKET Then Exit;
  ZeroMemory(@SockAddr, SizeOf(SockAddr));
  SockAddr.sin_family:=AF_INET;
  SockAddr.sin_port:=htons(FServerPort);
  SockAddr.sin_addr.S_addr:=htonl(FServerIp);
  If connect(FServerConnection, SockAddr, SizeOf(SockAddr)) = SOCKET_ERROR Then Exit;
  Write('Connection to server established.');
  Result:=True;
end;

function TClientThread.Execute:Integer;
var
  fs:TFDSet;
  ITrue:Integer;
begin
  Result:=-1;
  CurrentClientThread := Self;
  Write('Thread in.');
  If not ConnectToServer Then Exit;
  ITrue:=1;
  ioctlsocket(FClientConnection, FIONBIO, ITrue);
  ioctlsocket(FServerConnection, FIONBIO, ITrue);
  FCSObj:=TPacketStream.Create(FClientConnection, FServerConnection);
  FSCObj:=TPacketStream.Create(FServerConnection, FClientConnection);
  FSCObj.Seed:=1;
  FSCObj.OnPacket:=OnSCPacket;
  FCSObj.OnPacket:=OnCSPacket;
  FSCObj.IsCliServ:=False;
  FCSObj.IsCliServ:=True;
  {$IFDEF Debug}
  FSCObj.DebugPresend:=IntToStr(FServerIp shr 24) + '.' + IntToStr((FServerIp shr 16) and $FF) + '.' + IntToStr((FServerIp shr 8) and $FF) + '.' + IntToStr(FServerIp and $FF) + ':' + IntToStr(FServerPort) + ' ';
  FCSObj.DebugPresend:=FSCObj.DebugPresend;
  Write('Client thread ready to work.');
  {$ENDIF}
  repeat
    FD_ZERO(fs);
    FD_SET(FClientConnection, fs);
    FD_SET(FServerConnection, fs);
    select(0, @fs, nil, nil, @TV_Timeout);
    If FD_ISSET(FClientConnection, fs) Then Begin
      If not FCSObj.ProcessNetworkData Then FNeedExit := True;
    End;
    If FD_ISSET(FServerConnection, fs) Then Begin
      If not FSCObj.ProcessNetworkData Then FNeedExit := True;
    end;
    FCSObj.Flush;
    FSCObj.Flush;
    PluginSystem.CheckSyncEvent;
  until FNeedExit;
  Write('Connection terminated by some reason.');
  Result:=0;
  ITrue:=0;
  ioctlsocket(FClientConnection, FIONBIO, ITrue);
  ioctlsocket(FServerConnection, FIONBIO, ITrue);
  closesocket(FClientConnection);
  closesocket(FServerConnection);
  FCSObj.Free;
  FSCObj.Free;
  If CurrentClientThread = Self Then CurrentClientThread := nil;
  Write('Thread out.');
end;

procedure TClientThread.OnCSPacket(Sender:TObject; Packet:Pointer; var Length:Cardinal; var Process:Boolean);
begin
  {$IFDEF Debug}
  Write('C->S: Packet: Header: 0x' + IntToHex(PByte(Packet)^, 2) + ' Length: ' + IntToStr(Length));
  WriteDump(Packet, Length);
  {$ENDIF}
  If PByte(Packet)^=239 Then Begin
    FSCObj.Seed:=PCardinal(Cardinal(Packet) + 1)^;
    {$IFDEF Debug}
    Write('Seed is '+ IntToStr(FSCObj.Seed));
    {$ENDIF}
  End;
  If PByte(Packet)^=145 Then Begin
    FSCObj.Compression:=True;
    {$IFDEF Debug}
    Write('S->C: Compression enabled.');
    {$ENDIF}
  End;
  Process := PluginSystem.ClienToServerPacket(Packet, Length);
end;

procedure TClientThread.OnSCPacket(Sender:TObject; Packet:Pointer; var Length:Cardinal; var Process:Boolean);
begin
  {$IFDEF Debug}
  Write('S->C: Packet: Header: 0x' + IntToHex(PByte(Packet)^, 2) + ' Length: ' + IntToStr(Length));
  WriteDump(Packet, Length);
  {$ENDIF}
  If PByte(Packet)^=140 Then Begin

    PCardinal(Cardinal(Packet) + 1)^:=  htonl(INADDR_LOOPBACK);
    PWord(Cardinal(Packet) + 5)^:=htons(FLocalPort);
    {$IFDEF Debug}
    Write('S->C: Logging into game server with Auth_ID: '+IntToStr(PCardinal(Cardinal(Packet) + 7)^));
    {$ENDIF}
  End;
  Process := PluginSystem.ServerToClientPacket(Packet, Length);
end;

function TClientThread.SendPacket(Packet: Pointer; Length: Cardinal; ToServer, Direct: Boolean; var Valid: Boolean):Boolean;
{$IFDEF DEBUG}
var
  oldSize: Cardinal;
{$ENDIF}
begin
  {$IFDEF DEBUG}
  oldSize := Length;
  {$ENDIF}
  If ToServer Then
    Valid := FCSObj.DoSendPacket(Packet, Length, Direct, True)
  Else
    Valid := FSCObj.DoSendPacket(Packet, Length, Direct, True);
  {$IFDEF DEBUG}
  If not Valid Then begin
    Write('Plugin''s packet is not correct. Size: ' + IntToStr(oldSize) + ' Expected: ' + IntToStr(Length));
    WriteDump(Packet, oldSize);
  End;
  {$ENDIF}
  Result := Valid;
end;

initialization
  TV_Timeout.tv_usec:=100;
  CurrentClientThread := nil;
end.
