**!UOExtProtocolHandler** - Fires when registered packet arrived

---


**!UOExtProtocolHandler** - Запускается тогда, когда приходит пакет на который этот хендлер был подписан.

## Синтаксис ##
```
procedure UOExtProtocolHandler(
  Packet: Pointer;
  Size: Cardinal
); stdcall;
```
## Параметры ##
Packet
  * **Тип**: Pointer
  * **Описание**: Указатель на первый байт данных пакета.
Size
  * **Тип**: Cardinal
  * **Описание**: Размер пакета.
## Замечания ##
Выполняется а потоке прокси-сервера и на этапе PE\_INIT
## Требования ##
Нет