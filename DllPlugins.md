**TDllPlugins** - Describes plugins in plugins library.

---


**TDllPlugins** - Описывает плагины в бибилиотеке плагинов.

## Синтаксис ##
```
  TDllPlugins=packed record
    PluginsCount: Cardinal;
    Plugins: Array [0..0] of PPluginInfo;
  end;
  PDllPlugins=^TDllPlugins;
```
## Параметры ##
PluginsCount
  * **Тип**: Cardinal
  * **Описание**: Количество плагинов в бибилиотеке плагинов.
!Plugins
  * **Тип**: Array of P[PluginInfo](PluginInfo.md)
  * **Описание**: Массив ссылок на информацию по плагина.
## Замечания ##
Для тех, кто не знаком с Delphi - прием Array [0..0] of type - это метод записи массива с неопределенным количеством элементов внутри. Всегда должен идти последним в структуре.

Описывает плагины, которые находятся в бибилиотеки плагинов.