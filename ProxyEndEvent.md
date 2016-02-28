**PE\_ProxyEndEvent** - Describes reasons in PE\_PROXYEND event.

---


**PE\_ProxyEndEvent** - Описывает причины наступления события PE\_PROXYEND.

## Синтаксис ##
```
  TPE_ProxyEndEvent = packed record
    ConnectedToServer: Boolean;
    ConnectedToClient: Boolean;
    ServerCloseReason: Integer;
    ClientCloseReason: Integer;
  end;
  PPE_ProxyEndEvent = ^ TPE_ProxyEndEvent;
```
## Параметры ##
ConnectedToServer
  * **Тип**: Boolean
  * **Описание**: Подключен-ли к серверу на момент вызова события
ConnectedToClient
  * **Тип**: Boolean
  * **Описание**: Подключен-ли к клиенту на момент вызова события
ServerCloseReason
  * **Тип**: Integer
  * **Описание**: Причина закрытия подключения к серверу (Результат WSAGetLastError)
ClientCloseReason
  * **Тип**: Integer
  * **Описание**: Причина закрытия подключения к клиенту (Результат WSAGetLastError)
## Замечания ##
Содержит состояние и причины закрытия подключений.
На момент вызова PE\_PROXYEND подключения к клиенту и серверу принудительно еще не закрыты. В это время можно вызывать SendPacket и UOExtSendPacket если соответствующее подключение не закрыто, отправляя таким образом последнюю информацию, если это необходимо.