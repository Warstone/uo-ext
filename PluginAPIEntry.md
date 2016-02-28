#sidebar TableOfContents
**TPluginAPIEntry** - Describes single exported procedure in plugin descriptors.

---


**TPluginAPIInfo** - Описывает одну процедуру, экспортированную в дескрипторах плагинов.

## Синтаксис ##
```
  TPluginAPIEntry=packed record
    AName: PAnsiChar;
    AnAPI: Pointer;
    Flags: Cardinal;
  end;
  PPluginAPIEntry = ^TPluginAPIEntry;
```
## Параметры ##
AName
  * **Тип**: PAnsiChar
  * **Описание**: Ссылка на нуль-терминированную ANSI строку, содержащую название функции
AnAPI
  * **Тип**: Pointer;
  * **Описание**: Указатель на начело процедуры
Flags
  * **Тип**: Cardinal;
  * **Описание**: Флаги экспортируемой процедуры
## Замечания ##
Возможные значения флагов:
| Название | Значение | Описание |
|:---------|:---------|:---------|
| UF\_INPROXY | 1        | API функция может вызываться из потока прокси-сервера |
| UF\_INCLIENT | 2        | API функция может вызываться из потока клиента (например при перехвате API) |
| UF\_THREADSAFE | 4        | API функция является потокобезопасной и может вызываться в любом потоке (исключая прокси и клиент) |
| UF\_ALLTHREADS | 7        | API функция может выполняться откуда угодно |
| UF\_MAKETRAMPOLINECHECK | 8        | (Не реализовано) UOExt должна сгенерировать трамплин для этой функции с проверкой флагов. |