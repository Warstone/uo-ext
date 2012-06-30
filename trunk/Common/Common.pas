unit Common;

interface

uses Windows;

type
  TByteArray = Array [0..32767] of Byte;
  PByteArray = ^TByteArray;

function IntToStr(Value: Integer): AnsiString; overload;
function IntToStr(Value: Int64): AnsiString; overload;
function IntToHex(Value: Int64; Digits: Integer): AnsiString;
function StrToInt(const S: AnsiString): Integer;
function UpperCase(const S: AnsiString): AnsiString;

function FileExists(const AFilePath: AnsiString): Boolean;

function ExtractFilePath(const FileName: AnsiString): AnsiString;

function Trim(const S: AnsiString): AnsiString;

function SwapBytes2(Value: Word): Word;
function SwapBytes4(Value: Cardinal): Cardinal;

function GetExeVersion(var Major, Minor, Build: Cardinal): Boolean;

function Split2(const Splitter:AnsiString; const ToSplit: AnsiString; var Right: AnsiString):AnsiString;

implementation

function IntToStr(Value: Int64): AnsiString;
begin
  Str(Value, Result);
end;

function IntToStr(Value: Integer): AnsiString;
begin
  Str(Value, Result);
end;

function StrToInt(const S: AnsiString): Integer;
var
  E: Integer;
begin
  Val(String(S), Result, E);
  if E <> 0 then Result := 0;
end;

function IntToHex(Value: Int64; Digits: Integer): AnsiString;
var
  i: Integer;
const
  Hex: AnsiString = '0123456789ABCDEF';
begin
  Result := '';
  For i := 0 to Digits - 1 do begin
    Result := Hex[(Value mod 16) + 1] + Result;
    Value := Value div 16;
  end;
end;

function UpperCase(const S: AnsiString): AnsiString;
var
  Ch: AnsiChar;
  L: Integer;
  Source, Dest: PAnsiChar;
begin
  L := Length(S);
  SetLength(Result, L);
  Source := Pointer(S);
  Dest := Pointer(Result);
  while L <> 0 do
  begin
    Ch := Source^;
    if (Ch >= 'a') and (Ch <= 'z') then Dec(Ch, 32);
    Dest^ := Ch;
    Inc(Source);
    Inc(Dest);
    Dec(L);
  end;
end;

function FileExists(const AFilePath: AnsiString): Boolean;
Begin
  Result := Windows.GetFileAttributesA(PAnsiChar(AFilePath)) <> INVALID_FILE_ATTRIBUTES;
End;

function ExtractFilePath(const FileName: AnsiString): AnsiString;
var
  i: Integer;
begin
  Result := '';
  for i := Length(FileName) downto 1 do if FileName[i]='\' Then Begin
    Result := Copy(FileName, 1, i);
    Break;
  End;
end;

function Trim(const S: AnsiString): AnsiString;
var
  I, L: Integer;
begin
  L := Length(S);
  I := 1;
  while (I <= L) and (S[I] <= ' ') do Inc(I);
  if I > L then Result := '' else
  begin
    while S[L] <= ' ' do Dec(L);
    Result := Copy(S, I, L - I + 1);
  end;
end;

function SwapBytes2(Value: Word): Word;
Begin
  Result := (Value SHR 8) OR ((Value AND $FF) SHL 8);
End;

function SwapBytes4(Value: Cardinal): Cardinal;
Begin
  Result := (Value SHR 24) OR
            ((Value SHR 8) AND $FF00) OR
            ((Value AND $FF00) SHL 8) OR
            ((Value AND $FF) SHL 24);
End;

function GetExeVersion(var Major, Minor, Build: Cardinal): Boolean;
var
  ExeName : Array [0..MAX_PATH] of AnsiChar;
  ExeNameLength, cTmp, cFVLen, cFileVersionLen: Cardinal;
  pFileVersion, pFileInfo: Pointer;
Begin
  Result := False;
  ExeNameLength := GetModuleFileName(0, @ExeName[0], MAX_PATH);
  If ExeNameLength = 0 Then Exit;
  cFVLen := GetFileVersionInfoSize(@ExeName[0], cTmp);
  pFileVersion := GetMemory(cFVLen);
  GetFileVersionInfo(@ExeName[0], 0, cFVLen, pFileVersion);
  If not VerQueryValue(pFileVersion, '\', pFileInfo, cFileVersionLen) Then Exit;

  Major := HiWord(PVSFixedFileInfo(pFileInfo)^.dwFileVersionMS);
  Minor := LoWord(PVSFixedFileInfo(pFileInfo)^.dwFileVersionMS);
  Build := HiWord(PVSFixedFileInfo(pFileInfo)^.dwFileVersionLS);
  FreeMemory(pFileVersion);

  Result := True;
End;

function Split2(const Splitter:AnsiString; const ToSplit: AnsiString; var Right: AnsiString):AnsiString;
var
  i, j: Integer;
  Match: Boolean;
Begin
  for i := 1 to Length(ToSplit) - Length(Splitter) + 1 do if Splitter[1] = ToSplit[i] then Begin
    Match := True;
    for j := 1 to Length(Splitter) do if Splitter[j] <> ToSplit[i - 1 + j] then Begin
      Match := False;
      Break;
    End;
    If Match Then Begin
      SetLength(Result, i - 1);
      CopyMemory(@Result[1], @ToSplit[1], i - 1);
      SetLength(Right, Length(ToSplit) - i - Length(Splitter) + 1);
      CopyMemory(@Right[1], @ToSplit[i + Length(Splitter)], Length(Right));
      Exit;
    End;
  End;
  Result := '';
End;

end.
