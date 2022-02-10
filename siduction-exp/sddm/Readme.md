The sddm themes are *WIP*

Copy 2022-01-kde to /usr/share/themes/ and choose it from the systemsettings5 dialog.

Or test it with

```
sddm-greeter --test-mode --theme /usr/share/sddm/themes/2022-01-kde/
```

I had to choose an absolut path to the icon-theme, do not know why it doesn't work with relativ path, so it has to stay in /usr/share/sddm/themes, sorry for that.

I will investigate later, first it has to work.

It is a mod of the McMoya and breeze theme  (many thanks to you), so it only works with plasma/kde/kf5!

The 2022-01 theme is or own one.

You can test it with

```
sddm-greeter --test-mode --theme path/to/2022-01
```
