**TPluginDescriptor** - Describes some plugin property.

---


**TPluginDescriptor** - Описывает свойство плагина.

## Синтаксис ##
```
  TPluginDescriptor=packed record
    Descriptor: Cardinal;
    Value: Cardinal;
  end;
```
## Параметры ##
Descriptor
  * **Тип**: Cardinal
  * **Описание**: Описатель
Value
  * **Тип**: Cardinal
  * **Описание**: Значение
## Замечания ##
Список известных описателей:
| Symbollic descriptor | descriptor value | Value type | Description |
|:---------------------|:-----------------|:-----------|:------------|
| PD\_NAME             | 0                | PAnsiChar  | Название плагина. Значение указывает на символьную, нуль-терминированную строку в кодировке ANSI |
| PD\_UOEXTPROTO\_PACKETAMOUNT | 1                | Cardinal   | (Устарело)Количество подзаголовков в протоколе UOExt, необходимое данному плагину. Не может быть больше 255 |
| PD\_APIEXPORT        | 5                | PluginAPIInfo | Ссылка на описание экспортируемых API |
| PD\_HOOKPROTO        | 7                | Cardinal   | Булево. Если хотя-бы один плагин имеет этот описатель со значением 1, то UOExt будет перехватывать протокол |

Содержит описание определенного свойства плагина из приведенных в списке.