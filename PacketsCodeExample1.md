
```
uses Windows, WinSock, PluginAPI;

var
  HelloWorldPacket: Array [0..56] of Byte;

// Packet handler for 0x3A Packet
// Packet details: http://ruosi.org/packetguide/index.xml#server3A
function HelloHandler(Data: Pointer; var Size:Cardinal; var Send: Boolean; IsFromServerToClient: Boolean):Boolean stdcall;
var
  isValid: Boolean;
begin
  // Clear this handler
  API.UnRegisterPacketHandler($3A, @HelloHandler);
  // Send Hello packet
  API.SendPacket(@HelloWorldPacket, 57, False, True, isValid);
  // Send this packet to client
  Result := False;
end;

procedure Init;
var
  sDummy: AnsiString;
Begin
  // Register HelloHandler as handler for 0x3A packet
  API.RegisterPacketHandler($3A, @HelloHandler);

  // This is ASCII message generation.
  // Packet details: http://ruosi.org/packetguide/index.xml#server1C
  // Filling Hello world packet
  ZeroMemory(@HelloWorldPacket, 57);
  PByte(@HelloWorldPacket)^ :=  $1C; //Header (1Byte)
  PWord(Cardinal(@HelloWorldPacket) + 1)^ :=  htons(57); // SizeOfpacket (2Bytes)
  PCardinal(Cardinal(@HelloWorldPacket) + 3)^ :=  $FFFFFFFF; //Serial (4Bytes)
  PWord(Cardinal(@HelloWorldPacket) + 7)^ :=  $FFFF; // Graphic (2Bytes)
  PByte(Cardinal(@HelloWorldPacket) + 9)^ :=  $00; // MessageType (1Byte)
  PWord(Cardinal(@HelloWorldPacket) + 10)^ :=  htons($03B2); // Hue (2Bytes)
  PWord(Cardinal(@HelloWorldPacket) + 12)^ :=  htons($0003); // Font (2Bytes)
  sDummy := 'System';
  CopyMemory(PChar(Cardinal(@HelloWorldPacket) + 14), @sDummy[1], 6); // Name (30Bytes)
  sDummy := 'Hello World!';
  CopyMemory(PChar(Cardinal(@HelloWorldPacket) + 44), @sDummy[1], 12); // Message (Various)
End;
```