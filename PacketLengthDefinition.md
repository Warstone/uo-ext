**PacketLengthDefinition** - Returns length of a packet

---


**PacketLengthDefinition** - Возвращает длинну пакета

## Синтаксис ##
```
function PacketLengthDefinition(
  Packet:Pointer;
  Length:Cardinal
):Cardinal; stdcall;
```
## Параметры ##
Packet
  * **Тип**: Pointer
  * **Описание**: Указатель на первый байт предполагаемого пакета
Length
  * **Тип**: Cardinal
  * **Описание**: Длинна буфера с данными.
## Результат ##
Процедура возвращает длинну пакета (включая заголовок) или 0, если данных для анализа не хватает.
## Замечания ##
Если процедура написана неверно, то может случиться дедлок - когда прокси-сервер ожидает от сервера данных, а сервер считает что данные уже переданы.

Выполняется а потоке прокси-сервера.
## Требования ##
Нет
## Пример ##
Стандартный обработчик протокола в случае, если пакет динамической длинны:
```
function DefaultPacketHandler(Packet:Pointer; Length:Cardinal):Cardinal; stdcall;
var
  Len:PWord;
begin
  If Length<3 Then
    Result:=0
  else Begin
    Len:=PWord(Cardinal(Packet) + 1);
    Result:=(Len^ shr 8) + ((Len^ and $FF) shl 8);
  End;
end;
```