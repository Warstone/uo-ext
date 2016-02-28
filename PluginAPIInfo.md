#sidebar TableOfContents
**TPluginAPIInfo** - Describes exported API in plugin descriptors.

---


**TPluginAPIInfo** - Описывает экспортированное API в дескрипторах плагинов.

## Синтаксис ##
```
  TPluginAPIInfo=packed record
    Count: Cardinal;
    API: Array [0..0] of PPluginAPIEntry;
  end;
  PPluginAPIInfo = ^TPluginAPIInfo;
```
## Параметры ##
Count
  * **Тип**: Cardinal
  * **Описание**: Количество экспортируемых
API
  * **Тип**: Array of P[PluginAPIEntry](PluginAPIEntry.md);
  * **Описание**: Массив описателей экспортированного API
## Замечания ##
Содержит описание экспортированного API, передаваемого в UOExt для дальнейшего поиска.