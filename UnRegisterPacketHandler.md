**UnRegisterPacketHandler** - Unregisters a handler for packet


---


**UnRegisterPacketHandler** - Разрегистрирует обработчик пакета.

## Синтаксис ##
```
procedure UnRegisterPacketHandler(
	Header: Byte;
	Handler: TPacketHandler
) stdcall;
```
## Параметры ##
Header
  * **Тип**: Byte
  * **Описание**: Заголовок пакета, который необходимо прекратить перехватывать
Handler
  * **Тип**: T[PacketHandler](PacketHandler.md)
  * **Описание**: Процедура-обработчик перехватываемого пакета
## Замечания ##
Убирает регистрирацию обработчика пакета типа [PacketHandler](PacketHandler.md) для пакета с заголовком Header.

Один и тот-же обработчик пакетов может быть зарегистрировать для нескольких пакетов.
## Требования ##
Вызов процедуры необходимо делать в потоке прокси-сервера
## Пример ##
Пример использования **UnRegisterPacketHandler** можно найти в [PacketsCodeExample1](PacketsCodeExample1.md)