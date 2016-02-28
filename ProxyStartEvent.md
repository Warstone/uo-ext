#sidebar TableOfContents
**PE\_ProxyStartEvent** - Describes sockets in PE\_PROXYSTART event.

---


**PE\_ProxyStartEvent** - Описывает сокеты, которые использовались для подключения в событии PE\_PROXYSTART.

## Синтаксис ##
```
  TPE_ProxyStartEvent = packed record
    ClientSocket: Cardinal;
    UOExtSocket: Cardinal;
    ServerSocket: Cardinal;
  end;
  PPE_ProxyStartEvent = ^ TPE_ProxyStartEvent;
```
## Параметры ##
ClientSocket
  * **Тип**: Cardinal
  * **Описание**: Сокет, который создал клиент для подключения к серверу
!UOExtSocket
  * **Тип**: Cardinal
  * **Описание**: Сокет, который создал UOExt для эмуляции сервера на локальном компьютере.
ServerSocket
  * **Тип**: Cardinal
  * **Описание**: Сокет, который создал UOExt для подключения к реальному серверу.
## Замечания ##
Содержит идентификаторы сокетов, которые созались для проксирования протокола.
В случае если реального проксирования не происходит, то ClientSocket = ServerSocket, а !UOExtSocket = INVALID\_SOCKET
На момент PE\_PROXYSTART все сокеты подключены.