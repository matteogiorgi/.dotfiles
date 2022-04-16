## Display manager

Run `systemctl enable ly.service` to enable the ly display manager.
To be able to use berrywm with it run `touch /usr/share/xsessions/berry.desktop` with the following content:

```
[Desktop Entry]
Encoding=UTF-8
Name=berry
Comment=berry - a small window manager
Exec=berry
Type=XSession
```
