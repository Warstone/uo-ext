**TAPI** - Describes API in PE\_INIT event.

---


**TAPI** - Описывает API в событии PE\_INIT.

## Синтаксис ##
```
  TAPI = packed record
    APICount: Cardinal;
    APIs: Array [0..0] of TAPIFunc;
  end;
```
## Параметры ##
APICount
  * **Тип**: Cardinal
  * **Описание**: Количество экспортируемых API
APIs
  * **Тип**: Array of [APIFunc](APIFunc.md);
  * **Описание**: Массив описателей API
## Замечания ##
Содержит описание API, передаваемого в плагин для взаимодействия с UOExt