**!UOExtProtocolRegisterHandler** - Registers ahandler for UOExt packet


---


**!UOExtProtocolRegisterHandler** - Регистрирует обработчик пакета UOExt протокола.

## Синтаксис ##
```
procedure UOExtProtocolRegisterHandler(
  Header:Byte;
  Handler:TUOExtProtocolHandler
); stdcall;
```
## Параметры ##
Header
  * **Тип**: Byte
  * **Описание**: Заголовок пакета, который необходимо перехватить
Handler
  * **Тип**: T[UOExtProtocolHandler](UOExtProtocolHandler.md)
  * **Описание**: Процедура-обработчик перехватываемого пакета
## Замечания ##
Регистрирует обработчик пакета типа [UOExtProtocolHandler](UOExtProtocolHandler.md) для пакета с заголовком Header.

Один и тот-же обработчик пакетов может быть зарегистрирован для нескольких пакетов.

Внимание: Процесс взаимодействия с сервером обновлений не закончится, пока все зарегистрированные обработчики не будут разрегестрированны через [UOExtProtocolUnRegisterHandler](UOExtProtocolUnRegisterHandler.md)
## Требования ##
Вызов процедуры необходимо делать в потоке прокси-сервера или на этапе PE\_INIT
## Пример ##
Нет