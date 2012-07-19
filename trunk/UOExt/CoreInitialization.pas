unit CoreInitialization;

interface

function CoreInitialize:Byte; stdcall;

implementation

uses Windows, HookLogic, Plugins, Common, WinSock, ShardSetup, zLib,
  GUI, ProtocolDescription, Updater;

{$IFDEF DEBUG}
  {$DEFINE DEBUGWINDOW}
{$ENDIF}

{$IFDEF DEBUGWINDOW}
function HandlerRoutine(dwCtrlType: cardinal): bool; stdcall;
begin
  case dwCtrlType of
    CTRL_CLOSE_EVENT: begin
      FreeConsole;
      Result := True;
    end;
    else Result := false;
  end;//of case
end;

var
  oldDllProc : TDLLProc;

procedure Terminator(Reason: Integer);
begin
  If Reason = DLL_PROCESS_DETACH Then
    FreeConsole;
  If Assigned(oldDllProc) Then oldDllProc(Reason);
end;
{$ENDIF}

procedure CreateConsole;
{$IFDEF DEBUGWINDOW}
var
  AlreadyAllocated: Boolean;
{$ENDIF}
Begin
  {$IFDEF DEBUGWINDOW}
  AlreadyAllocated := GetFileType(GetStdHandle(STD_OUTPUT_HANDLE)) <> FILE_TYPE_UNKNOWN;
  If not AlreadyAllocated Then AllocConsole;
  TTextRec(Output).Handle := GetStdHandle(STD_OUTPUT_HANDLE);
  TTextRec(ErrOutput).Handle := GetStdHandle(STD_ERROR_HANDLE);
  SetConsoleCtrlHandler(@HandlerRoutine, True);
  oldDllProc := DllProc;
  DllProc := @Terminator;

  if AlreadyAllocated then Begin
    WriteLn;
    WriteLn('UOExt.dll was successfully updated (or it think so).');
    WriteLn;
  End;
  WriteLn('UOExt.dll Ultima Online (C) protocol and client patch system.');
  WriteLn('Core: Debug window started.');
  WriteLn;
  Write('Core: Compile time directives: DEBUGWINDOW');
  {$IFDEF DEBUG} Write(', DEBUG'); {$ENDIF}
  {$IFDEF RELEASE} Write(', RELEASE');{$ENDIF}
  {$IFDEF WRITELOG} Write(', WRITELOG');{$ENDIF}
  WriteLn;
  {$ELSE}
  If GetFileType(GetStdHandle(STD_OUTPUT_HANDLE)) <> FILE_TYPE_UNKNOWN Then FreeConsole;
  {$ENDIF}
End;

procedure CriticalError(Msg: AnsiString);
Begin
  {$IFDEF Debug}
  WriteLn(Msg);
  WriteLn('Press any key to exit.');
  Readln;
  {$ELSE}
  Msg := Msg + #0;
  MessageBoxA(0, @Msg[1], nil, MB_OK);
  {$ENDIF}
  Halt(1);
End;

procedure GetIPOverride;
var
  Host, sPort: AnsiString;
  rHost: PHostEnt;
  WSAData: TWSAData;
Begin
  if ParamCount >= 1 then Begin
    WSAStartup($101, WSAData);
    Host := Split2(':', AnsiString(ParamStr(1)), sPort);
    Host := Host + #0;
    rHost := gethostbyname(@Host[1]);
    ShardSetup.Port := htons(StrToInt(sPort));
    ShardSetup.IP := PCardinal(rHost.h_addr_list)^;
    WSACleanup;
  End;
End;

function InProcess:Byte;
var
  Updater: TUpdater;
  Res: Integer;
  uMainLine: Cardinal;
  uStatusLine: Cardinal;
Begin
  Result := 2;

  ShardSetup.UOExtBasePath := ExtractFilePath(AnsiString(ParamStr(0)));

// Check for IP override
  GetIPOverride;

// Create console if needed
  CreateConsole;

// Create GUI
  GUI.CurrGUI := TGUI.Create;
  GUI.CurrGUI.Init(ShardSetup.UOExtBasePath + ShardSetup.GUIDLLName);

  uMainLine := GUI.GUISetLog($FFFFFFFF, $FFFFFFFF, 'Initializing ... ');
  uStatusLine := GUI.GUISetLog($FFFFFFFF, uMainLine, 'Loading protocol info');

// Init Protocol info.
  ProtocolDescription.Init;

// Try to connect to server and ask for support
  GUI.GUISetLog(uStatusLine, uMainLine, 'Performing self-update');
  Updater := TUpdater.Create;

// For initial handshake we need MD5 for self, and GUI
  If not Updater.GatherMD5Info Then CriticalError('Core: Can''t get MD5 sizes of myself and GUI. Critical!');

// If all ok, then we are ready for connection
  {$IFDEF DEBUG}
  WriteLn('Core: Asking server for UOExt support.');
  {$ENDIF}
  If Updater.Connect Then Begin
    {$IFDEF DEBUG}
    WriteLn('Core: UOExt supported. Config:');
    Write('Core:  Server side protocol is ');
    if ShardSetup.Encrypted then WriteLn('encrypted') else WriteLn('unencrypted');
    WriteLn('Core:  UOExt protocol encapsulation header: ', IntToHex(ShardSetup.InternalProtocolHeader, 2));
    {$ENDIF}
  End Else Begin
   {$IFDEF DEBUG}
   WriteLn('Core: UOExt is not supported on this server. Gracefull exit.');
   Sleep(5000);
   {$ENDIF}
   Exit;
  End;

// Ok. We get some info about self-updating. Update if need.
  Res := Updater.SelfUpdate;
  If Res = 0 Then Begin
    {$IFDEF DEBUG}
    WriteLn('Core: Core is up to date.');
    {$ENDIF}
  End Else If Res = 1 then Begin
    {$IFDEF DEBUG}
    WriteLn('Core: Core has been updated. Reloading...');
    {$ENDIF}
    Updater.Cleanup;
    Result := 1;
    Exit;
  End Else if Res = 2 then Begin
    {$IFDEF DEBUG}
    WriteLn('Core: GUI has been updated.');
    {$ENDIF}
    if not GUI.CurrGUI.Reload Then CriticalError('Core: Failed to reload GUI. Critical!');
    uStatusLine := $FFFFFFFF;
    uMainLine := $FFFFFFFF;
  End Else if Res = -1 then Begin
    CriticalError('Core: Failed to self-update. Critical!');
  End;

// Ok. We are now updated and still running! It's time to load plugins
  GUI.GUISetLog(uStatusLine, uMainLine, 'Updating plugins');
  If not Updater.GetDllsFromServer Then Begin
    CriticalError('Core: Can''t load plugins from server. Critical!');
  End;

// Hook needed WinAPI, before plugins init.
  uStatusLine := GUI.GUISetLog($FFFFFFFF, uMainLine, 'Hooking');
  {$IFDEF DEBUG}
  Write('Core: Hooking APIs for launch ... ');
  {$ENDIF}
  HookIt;

  // Ok. All Init is done! Loading plugins.
  GUI.GUISetLog(uStatusLine, uMainLine, 'Initializing plugins.');
  {$IFDEF DEBUG}
  WriteLn('done.');
  WriteLn('Core: Starting plug-ins loading.');
  {$ENDIF}
  TPluginSystem.Instance.Initialize(Updater);

  // Now we need to allow plugins to work with update server
//  TPluginSystem.Instance.InvokeUpdateProcess(Updater);

// Now we need to close update connection if needed
  Updater.Cleanup;
  if not ShardSetup.PersistentConnect then Updater.Free;


// Clean GUI. It's need only on Initialize process.
  GUI.CurrGUI.Free;
  GUI.CurrGUI := nil;

  Result := 0;
End;

function CoreInitialize:Byte; stdcall;
Begin
  Result := InProcess;
  {$IFDEF DEBUGWINDOW}
  if Result = 2 then FreeConsole;
  {$ENDIF}
  if Assigned(GUI.CurrGUI) then GUI.CurrGUI.Free;
End;

end.
