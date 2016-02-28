**TPluginInfo** - Describes plugin.

---


**TPluginInfo** - Описывает плагин.

## Синтаксис ##
```
  TPluginInfo=packed record
    InitProcedure: TPluginProcedure;
    DescriptorsCount: Cardinal;
    Descriptors: Array [0..0] of TPluginDescriptor;
  end;
  PPluginInfo=^TPluginInfo;
```
## Параметры ##
InitProcedure
  * **Тип**: Ссылка на T[PluginProcedure](PluginProcedure.md)
  * **Описание**: Ссылка на [PluginProcedure](PluginProcedure.md) - основную процедуру "взаимодействия" с плагином.
DescriptorsCount
  * **Тип**: Cardinal
  * **Описание**: Количество описателей плагина.
!Descriptors
  * **Тип**: Array of T[PluginDescriptor](PluginDescriptor.md)
  * **Описание**: Описатели плагина.
## Замечания ##
Для тех, кто не знаком с Delphi - прием Array [0..0] of type - это метод записи массива с неопределенным количеством элементов внутри. Всегда должен идти последним в структуре.

Описывает конекретный плагин.