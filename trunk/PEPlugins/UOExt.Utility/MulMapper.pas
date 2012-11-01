unit MulMapper;

interface

uses UOExt.Utility.Bindings;

  procedure AskForMulMapping; stdcall;
  function GetMulMappingInfo(AMulName:PAnsiChar):PMappingRec; stdcall;

implementation

uses Windows, Common, APIHooker, ExecutableSections;

type
  PMappingPage=^TMappingPage;
  TMappingPage=record
    Size: Cardinal;
    Next: PMappingPage;
    Mapping: Array [0..0] of TMappingRec;
  end;

var
  Mapping: PMappingPage;
  LastMappingPage: PMappingPage;

function CreateFileAHook(ACaller: Cardinal; lpFileName: PAnsiChar; dwDesiredAccess, dwShareMode: DWORD;
  lpSecurityAttributes: PSecurityAttributes; dwCreationDisposition, dwFlagsAndAttributes: DWORD;
  hTemplateFile: THandle): THandle; stdcall;
type
  TCreateFileA = function(lpFileName: PAnsiChar; dwDesiredAccess, dwShareMode: DWORD;
  lpSecurityAttributes: PSecurityAttributes; dwCreationDisposition, dwFlagsAndAttributes: DWORD;
  hTemplateFile: THandle): THandle; stdcall;
var
  s:AnsiString;
  i:integer;
  bFound: Boolean;
begin
  if not IsAddressFromExecutable(ACaller) then Begin
    THooker.Hooker.TrueAPI;
    Result := TCreateFileA(GetProcAddress(GetModuleHandle('kernel32.dll'), 'CreateFileA'))(lpFileName, dwDesiredAccess, dwShareMode, lpSecurityAttributes, dwCreationDisposition, dwFlagsAndAttributes, hTemplateFile);
    THooker.Hooker.TrueAPIEnd;
    Exit;
  End;

  s:=lpFileName;
  i:=Length(s);
  repeat
    if s[i]='.' then begin
      s:=Copy(s, i + 1, Length(s));
      Break;
    end;
    Dec(i);
  until i=0;
  s := UpperCase(s);
  if (s = 'MUL') or (s = 'IDX') then Begin
    dwDesiredAccess := GENERIC_READ + GENERIC_WRITE;
    dwShareMode := FILE_SHARE_READ + FILE_SHARE_WRITE;
  End;

  THooker.Hooker.TrueAPI;
  Result := TCreateFileA(GetProcAddress(GetModuleHandle('kernel32.dll'), 'CreateFileA'))(lpFileName, dwDesiredAccess, dwShareMode, lpSecurityAttributes, dwCreationDisposition, dwFlagsAndAttributes, hTemplateFile);
  THooker.Hooker.TrueAPIEnd;

  if (s = 'MUL') or (s = 'IDX') then Begin
    s:=lpFileName;
    i:=Length(s);
    repeat
      if s[i]='\' then begin
        s:=Copy(s, i + 1, Length(s));
        Break;
      end;
      Dec(i);
    until i=0;
    s := UpperCase(s);

    bFound := False;
    if LastMappingPage <> nil then Begin
      for i := 0 to LastMappingPage^.Size - 1 do if LastMappingPage^.Mapping[i].MappingPointer = nil then Begin
        LastMappingPage^.Mapping[i].FileHandle := Result;
        LastMappingPage^.Mapping[i].FileName := GetMemory(Length(s) + 1);
        ZeroMemory(LastMappingPage^.Mapping[i].FileName, Length(s) + 1);
        CopyMemory(LastMappingPage^.Mapping[i].FileName, @s[1], Length(s));
        bFound := True;
        Break;
      End;
    End;
    if not bFound then Begin
      if LastMappingPage <> nil then Begin
        LastMappingPage.Next := GetMemory(SizeOf(TMappingPage) + SizeOf(TMappingRec)*9);
        LastMappingPage := LastMappingPage.Next;
      End Else Begin
        LastMappingPage := GetMemory(SizeOf(TMappingPage) + SizeOf(TMappingRec)*9);
        Mapping := LastMappingPage;
      End;
      LastMappingPage.Size := 10;
      for i := 0 to 9 do Begin
        LastMappingPage.Mapping[i].MappingPointer := nil;
      End;

      LastMappingPage^.Mapping[0].FileHandle := Result;
      LastMappingPage^.Mapping[0].FileName := GetMemory(Length(s) + 1);
      ZeroMemory(LastMappingPage^.Mapping[0].FileName, Length(s) + 1);
      CopyMemory(LastMappingPage^.Mapping[0].FileName, @s[1], Length(s));
    End;
  End;
end;

function CloseHandleHook(ACaller: Cardinal; hObject: THandle): BOOL; stdcall;
var
  i: Integer;
  Current: PMappingPage;
begin
  THooker.Hooker.TrueAPI;
  Result := CloseHandle(hObject);
  THooker.Hooker.TrueAPIEnd;

  If Result AND IsAddressFromExecutable(ACaller) Then Begin
    if Mapping = nil then Exit;
    Current := Mapping;
    repeat
      For i := 0 to Current.Size - 1 do Begin
        if Current.Mapping[i].FileHandle = hObject then Current.Mapping[i].FileHandle := INVALID_HANDLE_VALUE;
        if Current.Mapping[i].MappingHandle = hObject then Current.Mapping[i].MappingHandle := INVALID_HANDLE_VALUE;
      End;
      Current := Current.Next;
    until Current = nil;
  End;
end;

function CreateFileMappingAHook(ACaller:Cardinal; hFile: THandle; lpFileMappingAttributes: PSecurityAttributes;
  flProtect, dwMaximumSizeHigh, dwMaximumSizeLow: DWORD; lpName: PAnsiChar): THandle; stdcall;
var
  i: Integer;
  bFutherProcessing: Boolean;
  Current: PMappingPage;
Begin
  if not IsAddressFromExecutable(ACaller) then Begin
    THooker.Hooker.TrueAPI;
    Result := CreateFileMappingA(hFile, lpFileMappingAttributes, flProtect, dwMaximumSizeHigh, dwMaximumSizeLow, lpName);
    THooker.Hooker.TrueAPIEnd;
    Exit;
  End;

  bFutherProcessing := False;
  If hFile <> INVALID_HANDLE_VALUE Then If Mapping <> nil then Begin
    Current := Mapping;
    Repeat
      for i := 0 to Current.Size - 1 do if Current.Mapping[i].FileHandle = hFile then Begin
        flProtect := PAGE_READWRITE;
        bFutherProcessing := True;
        Break;
      End;
      if bFutherProcessing then Break;
      Current := Current.Next;
    Until Current = nil;
  End;

  THooker.Hooker.TrueAPI;
  Result := CreateFileMappingA(hFile, lpFileMappingAttributes, flProtect, dwMaximumSizeHigh, dwMaximumSizeLow, lpName);
  THooker.Hooker.TrueAPIEnd;

  If (Result <> INVALID_HANDLE_VALUE) and bFutherProcessing Then Begin
    Current := Mapping;
    Repeat
      For i := 0 to Current.Size - 1 do if Current.Mapping[i].FileHandle = hFile then Begin
        Current.Mapping[i].MappingHandle := Result;
        bFutherProcessing := False;
        Break;
      End;
      if not bFutherProcessing then Break;
      Current := Current.Next;
    Until Current = nil;
  End;
End;

function MapViewOfFileHook(ACaller:Cardinal; hFileMappingObject: THandle; dwDesiredAccess: DWORD;
  dwFileOffsetHigh, dwFileOffsetLow, dwNumberOfBytesToMap: DWORD): Pointer; stdcall;
type
  RIndexRec = packed record
    Lookup: Cardinal;
    Size: Cardinal;
    Extra: Cardinal;
  end;
  PIndexRec = ^RIndexRec;
var
  i: Byte;
  Current: PMappingPage;
  bFutherProcessing: Boolean;
Begin
  if not IsAddressFromExecutable(ACaller) then Begin
    THooker.Hooker.TrueAPI;
    Result := MapViewOfFile(hFileMappingObject, dwDesiredAccess, dwFileOffsetHigh, dwFileOffsetLow, dwNumberOfBytesToMap);
    THooker.Hooker.TrueAPIEnd;
    Exit;
  End;

  bFutherProcessing := False;
  If Mapping <> nil then Begin
    Current := Mapping;
    Repeat
      for i := 0 to Current.Size - 1 do if Current.Mapping[i].MappingHandle = hFileMappingObject then Begin
        dwDesiredAccess := FILE_MAP_ALL_ACCESS;
        bFutherProcessing := True;
        Break;
      End;
      if bFutherProcessing then Break;
      Current := Current.Next;
    Until Current = nil;
  End;

  THooker.Hooker.TrueAPI;
  Result := MapViewOfFile(hFileMappingObject, dwDesiredAccess, dwFileOffsetHigh, dwFileOffsetLow, dwNumberOfBytesToMap);
  THooker.Hooker.TrueAPIEnd;

  if (Result <> nil) AND (bFutherProcessing) then begin
    Current := Mapping;
    Repeat
      for i := 0 to Current.Size - 1 do if Current.Mapping[i].MappingHandle = hFileMappingObject then Begin
        Current.Mapping[i].MappingPointer := Result;
        bFutherProcessing := False;
        Break;
      End;
      if not bFutherProcessing then Break;
      Current := Current.Next;
    Until Current = nil;
  end;
End;

procedure AskForMulMapping; stdcall;
Begin
  Mapping := nil;
  LastMappingPage := nil;
  THooker.Hooker.HookFunction(@CreateFileAHook, GetProcAddress(GetModuleHandle('kernel32.dll'), 'CreateFileA'), TAddCallerFunctionHooker);
  THooker.Hooker.HookFunction(@CloseHandleHook, GetProcAddress(GetModuleHandle('kernel32.dll'), 'CloseHandle'), TAddCallerFunctionHooker);
  THooker.Hooker.HookFunction(@MapViewOfFileHook, GetProcAddress(GetModuleHandle('kernel32.dll'), 'MapViewOfFile'), TAddCallerFunctionHooker);
  THooker.Hooker.HookFunction(@CreateFileMappingAHook, GetProcAddress(GetModuleHandle('kernel32.dll'), 'CreateFileMappingA'), TAddCallerFunctionHooker);
  THooker.Hooker.InjectIt;
End;

function GetMulMappingInfo(AMulName:PAnsiChar):PMappingRec; stdcall;
var
  Current:PMappingPage;
  i: Cardinal;
  UCMulName: AnsiString;
Begin
  Result := nil;
  if Mapping = nil then Exit;

  SetLength(UCMulName, Length(AMulName));
  CopyMemory(@UCMulName[1], AMulName, Length(AMulName));
  UCMulName := UpperCase(UCMulName);
  Current := Mapping;
  Repeat
    for i := 0 to Current.Size - 1 do if UCMulName = Current.Mapping[i].FileName then Begin
      Result := @Current.Mapping[i];
      Exit;
    End;
    Current := Current.Next;
  Until Current = nil;


End;



end.
