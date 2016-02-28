**!UOExtProtocolSendPacket** - Sends packet to server


---


**!UOExtProtocolSendPacket** - Посылает пакет серверу.

## Синтаксис ##
```
procedure UOExtProtocolSendPacket(
  Header:Byte;
  Packet: Pointer;
  Size: Cardinal
); stdcall;
```
## Параметры ##
Header
  * **Тип**: Byte
  * **Описание**: Заголовок пакета.
Packet
  * **Тип**: Pointer
  * **Описание**: Ссылка на начало пакета (Не включая заголовок и размер пакета).
Size
  * **Тип**: Cardinal
  * **Описание**: Размер пакета в байтах
## Замечания ##
Отсылает пакет серверу обновлений. UOExt сама "дособирает" пакет до текущей версии протокола.
## Требования ##
Вызов процедуры необходимо делать в потоке прокси-сервера и на этапе PE\_INIT