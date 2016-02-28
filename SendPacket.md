**SendPacket** - Sends packet to revicer


---


**SendPacket** - Посылает пакет получателю.

## Синтаксис ##
```
function SendPacket(
	Packet: Pointer;
	Length: Cardinal;
	ToServer: Boolean;
var	Valid: Boolean
): Boolean; stdcall;
```
## Параметры ##
Packet
  * **Тип**: Pointer
  * **Описание**: Ссылка на начало пакета.
Length
  * **Тип**: Cardinal
  * **Описание**: Размер пакета в байтах
ToServer
  * **Тип**: Boolean
  * **Описание**: Направление. True - пакет посылается на сервер, False - на клиент
Valid
  * **Тип**: Boolean
  * **Описание**: Возвращаемое значение. Является-ли пакет верным. Во время посылки пакета он сначала проверяется на соответствие протоколу и, если пакет неверный, - отсылка не производится.
## Результаты ##
Если отсылка пакета произошла успешно (пакет попал в исходящий буффер), то функция вернет True, в противном случае - False.
## Замечания ##
## Требования ##
## Пример ##
Пример использования **SendPacket** можно найти в PacketsCodeExample1