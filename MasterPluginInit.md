#sidebar TableOfContents
**TPE\_MasterPluginInit** - Describes API in PE\_MASTERINIT event.

---


**TPE\_MasterPluginInit** - Описывает API в событии PE\_MASTERINIT.

## Синтаксис ##
```
  TPE_MasterPluginInit = packed record
    API: PAPI;
    Result: Cardinal;
  end;
  PPE_MasterPluginInit = ^TPE_MasterPluginInit;
```
## Параметры ##
API
  * **Тип**: P[API](APIStruct.md)
  * **Описание**: Ссылка на экспортируемые API
Result
  * **Тип**: Cardinal;
  * **Описание**: Результат выполнения PE\_MASTERINIT
## Замечания ##
Содержит описание API, передаваемого в мастер-плагин для взаимодействия с UOExt, а так-же результат выполнения этой команды.
Возможные результаты:
|Значение|Описание|
|:-------|:-------|
| 0      | Все хорошо, продолжить загрузку |
| 1      | Ядро UOExt обновилось. Надо перезагрузить UOExt (клиент перезагружен не будет) |
| 2      | GUI обновилось. Надо перезагрузить GUI и заного показать его |
| 3      | Все плохо. Обновление не прошло. Загрузка прервется |
