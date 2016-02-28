**RegisterPacketHandler** - Registers a handler for packet


---


**RegisterPacketHandler** - Регистрирует обработчик пакета.

## Синтаксис ##
```
procedure RegisterPacketHandler(
	Header: Byte;
	Handler: TPacketHandler
) stdcall;
```
## Параметры ##
Header
  * **Тип**: Byte
  * **Описание**: Заголовок пакета, который необходимо перехватить
Handler
  * **Тип**: T[PacketHandler](PacketHandler.md)
  * **Описание**: Процедура-обработчик перехватываемого пакета
## Замечания ##
Регистрирует обработчик пакета типа [PacketHandler](PacketHandler.md) для пакета с заголовком Header.
## Требования ##
Вызов процедуры необходимо делать в потоке прокси-сервера
## Пример ##
Пример использования **RegisterPacketHandler** можно найти в [PacketsCodeExample1](PacketsCodeExample1.md)