**APIFunc** - Describes API function.

---


**APIFunc** - Описатель функции API.

## Синтаксис ##
```
  TAPIFunc = packed record
    FuncType: Cardinal;
    Func: Pointer;
  End;
```
## Параметры ##
FuncType
  * **Тип**: Cardinal
  * **Описание**: Тип экспортируемой API функции
Func
  * **Тип**: Pointer
  * **Описание**: Ссылка на экспортируемую функцию
## Замечания ##
Таблица экспортируемых функций:
| Название константы API | Значение константы | ссылка на соответствующую ей функцию |
|:-----------------------|:-------------------|:-------------------------------------|
| PF\_REGISTERPACKETHANDLER | 1                  | [RegisterPacketHandler](RegisterPacketHandler.md) |
| PF\_UNREGISTERPACKETHANDLER | 2                  | [UnRegisterPacketHandler](UnRegisterPacketHandler.md) |
| PF\_REGISTERPACKETTYPE | 3                  | [RegisterPacketType](RegisterPacketType.md) |
| PF\_SENDPACKET         | 4                  | [SendPacket](SendPacket.md)          |
| PF\_GETNEWSERIAL       | 5                  | [GetNewSerial](GetNewSerial.md)      |
| PF\_FREESERIAL         | 6                  | [FreeSerial](FreeSerial.md)          |
| PF\_GETSERVERSERIAL    | 7                  | [GetServerSerial](GetServerSerial.md) |
| PF\_GETCLIENTSERIAL    | 8                  | [GetClientSerial](GetClientSerial.md) |
| PF\_REGISTERSYNCEVENTHANDLER | 9                  | [RegisterSyncEventHandler](RegisterSyncEventHandler.md) |
| PF\_ASKSYNCEVENT       | 10                 | [AskSyncEvent](AskSyncEvent.md)      |
| PF\_ZLIBCOMPRESS2      | 11                 | [zLibCompress2](zLibCompress2.md)    |
| PF\_ZLIBDECOMPRESS     | 12                 | [zLibDecompress](zLibDecompress.md)  |
| PF\_AFTERPACKETCALLBACK | 13                 | [AfterPacketCallback](AfterPacketCallback.md) |
| PF\_UOEXTREGISTERPACKETHANDLER | 14                 | [UOExtRegisterPacketHandler](UOExtRegisterPacketHandler.md) |
| PF\_UOEXTUNREGISTERPACKETHANDLER | 15                 | [UOExtUnRegisterPacketHandler](UOExtUnRegisterPacketHandler.md) |
| PF\_UOEXTSENDPACKET    | 16                 | [UOExtSendPacket](UOExtSendPacket.md) |
| PF\_GUISETLOG          | 17                 | [GUISetLog](GUISetLog.md)            |
| PF\_GUISTARTPROCESS    | 18                 | [GUIStartProcess](GUIStartProcess.md) |
| PF\_GUIUPDATEPROCESS   | 19                 | [GUIUpdateProcess](GUIUpdateProcess.md) |

Содержит константное имя и ссылку на начало функции.