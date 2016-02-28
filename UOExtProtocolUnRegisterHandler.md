**!UOExtProtocolUnRegisterHandler** - Unregisters a handler for UOExt packet


---


**!UOExtProtocolUnRegisterHandler** - Разрегистрирует обработчик UOExt пакета.

## Синтаксис ##
```
procedure UnRegisterPacketHandler(
	Header: Byte;
	Handler: TUOExtProtocolHandler
) stdcall;
```
## Параметры ##
Header
  * **Тип**: Byte
  * **Описание**: Заголовок пакета, который необходимо прекратить перехватывать
Handler
  * **Тип**: T[UOExtProtocolHandler](UOExtProtocolHandler.md)
  * **Описание**: Процедура-обработчик перехватываемого пакета
## Замечания ##
Убирает регистрирацию обработчика пакета типа [UOExtProtocolHandler](UOExtProtocolHandler.md) для пакета с заголовком Header.

Один и тот-же обработчик пакетов может быть зарегистрировать для нескольких пакетов.

Внимание: Процесс взаимодействия с сервером обновлений не закончится, пока все зарегистрированные обработчики не будут разрегестрированны через [UOExtProtocolUnRegisterHandler](UOExtProtocolUnRegisterHandler.md)

## Требования ##
Вызов процедуры необходимо делать в потоке прокси-сервера
## Пример ##
Пример использования **UnRegisterPacketHandler** можно найти в PacketsCodeExample1