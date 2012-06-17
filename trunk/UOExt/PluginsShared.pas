unit PluginsShared;

interface

const
  {PluginEvents}
  PE_INIT        = 1; {Init Event. Arg is APIInfo}
  PE_FREE        = 2; {Free plugin}
  PE_PROXYSTART  = 3; {Proxy start}
  PE_PROXYEND    = 4; {Proxy end}

  {API Entries}
  PF_REGISTERPACKETHANDLER = 1;
  PF_UNREGISTERPACKETHANDLER = 2;
  PF_REGISTERPACKETTYPE = 3;
  PF_SENDPACKET = 4;
  PF_GETNEWSERIAL = 5;
  PF_FREESERIAL = 6;
  PF_GETSERVERSERIAL = 7;
  PF_GETCLIENTSERIAL = 8;
  PF_REGISTERSYNCEVENTHANDLER = 9;
  PF_ASKSYNCEVENT = 10;
  PF_ZLIBCOMPRESS2 = 11;
  PF_ZLIBDECOMPRESS = 12;
  PF_AFTERPACKETCALLBACK = 13;
  PF_UOEXTREGISTERPACKETHANDLER = 14;
  PF_UOEXTUNREGISTERPACKETHANDLER = 15;
  PF_UOEXTSENDPACKET = 16;
  PF_GUISETLOG = 17;
  PF_GUISTARTPROCESS = 18;
  PF_GUIUPDATEPROCESS = 19;


  // Plugin secriptors
  PD_NAME = 0;
  PD_UOEXTPROTO_PACKETAMOUNT = 1;
  (***
    Amount of packet headers that Plugin will need to comunicate with server
    If not present, than 0.
  ***)

type

  TPluginDescriptor=packed record
    Descriptor: Cardinal;
    Value: Cardinal;
  end;

  TPluginInfo=packed record
    InitProcedure: Pointer;
    DescriptorsCount: Cardinal;
    Descriptors: Array [0..0] of TPluginDescriptor;
  end;
  PPluginInfo=^TPluginInfo;

  TDllPlugins=packed record
    PluginsCount: Cardinal;
    Plugins: Array [0..0] of PPluginInfo;
  end;
  PDllPlugins=^TDllPlugins;

  TDllInit = function: PDllPlugins; stdcall;
  {***
    Procedure in Dll with name 'DllInit', that runs after LoadLibrary, returns Plugins entry point list.
  ***}
  TDllInitDone = procedure; stdcall;
  {***
    Procedure in Dll with name 'DllInitDone', that runs after DllInit to free data from Plugins pointer.
    May not present in Dll, if Plugin not need to free memory from Plugins pointer.
  ***}

  TPluginProcedure = function (APluginEvent: Cardinal; APluginEventData: Pointer): Boolean; stdcall;
  {***
    Defines in dll. One procedure inits one plugin.
  ***}

  TPacketHandler = function (Data: Pointer; var Size:Cardinal; var Send: Boolean; IsFromServerToClient: Boolean):Boolean; stdcall;
  (**
    Send - Send this package to reciver.
    Result - If true - this event breaks bubbling.
    If Send = false then Result forced to true.
  **)

  TPacketSendedCallback = procedure(APackeHead: Byte; lParam: Pointer; IsFromServerToClient: Boolean); stdcall;

  TUOExtPacketSendedCallback = procedure(APacketHead: Byte; lParam: Pointer); stdcall;

  TPacketLengthDefinition=function(Packet:Pointer; Length:Cardinal):Cardinal; stdcall;
  (**
    In this procedure you can't register or unregister handlers.
  **)

  TAPIFunc = packed record
    FuncType: Cardinal;
    Func: Pointer;
  End;
  TAPI = packed record
    APICount: Cardinal;
    APIs: Array [0..0] of TAPIFunc;
  end;
  PAPI=^TAPI;

  TPE_ProxyEndEvent = packed record
    ConnectedToServer: Boolean;
    ConnectedToClient: Boolean;
    ServerCloseReason: Integer;
    ClientCloseReason: Integer;
  end;
  PPE_ProxyEndEvent = ^ TPE_ProxyEndEvent;

  TRegisterPacketHandler = procedure(Header:Byte; Handler: TPacketHandler) stdcall;
  TUnRegisterPacketHandler = procedure(Header: Byte; Handler: TPacketHandler) stdcall;
  TRegisterPacketType = procedure(Header:Byte; Size:Word; HandleProc: TPacketLengthDefinition) stdcall;
  (**
    If HandleProc <> nil Than Size will be ignored.
    If Size = 0 and HandleProc = nil then default handler will work.
    Default handler think that packet size is word right after Header (2-nd and 3-d byte of the packet)

    If you want to make your own definitor (i.e:
      BYTE UOHeader
      BYTE YourHeader
      [WORD PacketSize] // Only if Packet has various size
      BYTES Data
    ) than you just need to write it ;)
  **)
  TSendPacket = function(Packet: Pointer; Length: Cardinal; ToServer, Direct: Boolean; var Valid: Boolean):Boolean; stdcall;
  TGetNewSerial = function(IsMobile:Boolean): Cardinal; stdcall;
  TFreeSerial = procedure(Serial: Cardinal); stdcall;
  TGetServerSerial = function(Serial:Cardinal):Cardinal; stdcall;
  TGetClientSerial = function(Serial:Cardinal):Cardinal; stdcall;
  TAfterPacketCallback = function(ACallBack: TPacketSendedCallback; lParam: Pointer):Boolean; stdcall;

  TSyncEvent = procedure; stdcall;
  TRegisterSyncEventHandler = function(Event: TSyncEvent): Pointer; stdcall;
  TAskSyncEvent = procedure(InterlockedValue: Pointer); stdcall;
  (**
    Can be called from anywhere. Thread safe. (Must be)
  **)

  TzLibCompress2 = function(dest: Pointer; var destLength: Integer; source: Pointer; sourceLength: Integer; quality: Integer):Integer; stdcall;
  TzLibDecompress = function(dest: Pointer; var destLength: Integer; source: Pointer; sourceLength: Integer):Integer; stdcall;

  (**
    UOExtProtocol stuff.
  **)
  TUOExtProtocolHandler = procedure(Packet: Pointer; Size: Cardinal); stdcall;
  TUOExtProtocolRegisterHandler = procedure(Header:Byte; Handler:TUOExtProtocolHandler); stdcall;
  TUOExtProtocolUnRegisterHandler = procedure(Header:Byte; Handler:TUOExtProtocolHandler); stdcall;
  TUOExtProtocolSendPacket = procedure(Header:Byte; Packet: Pointer; Size: Cardinal); stdcall;

  (**
    GUI visualization.
  **)
  TGUISetLog = function(LineHandle: Cardinal; ParentHandle: Cardinal; Data: PAnsiChar): Cardinal; stdcall;
  TGUIStartProcess = function(LineHandle, ParentHandle: Cardinal; ProcessLabel: PAnsiChar; Min, Max, Current: Cardinal): Cardinal; stdcall;
  TGUIUpdateProcess = procedure(ProcessHandle, Min, Max, Current: Cardinal); stdcall;
implementation

end.
