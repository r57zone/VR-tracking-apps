# (Ru) Приложения для отслеживания головы в VR

## GoPro VR Player OpenTrack
Приложение для отслеживания вращения головы, в GoPro VR Player, с помощью любого [OpenTrack](https://github.com/opentrack/opentrack/releases/) трекера. 

**Настройка**
1. Загрузить, установить и настроить OpenTrack (добавить горячую клавишу для сброса центровки, настроить чувствительность, изменить выходной интерфейс на "UDP over network" и задать IP "127.0.0.1" в настройках выходного интерфейса).
2. Запустить программу.

## Razor IMU GoPro VR Player
Приложение для отслеживания вращения головы, в GoPro VR Player, с помощью Arduino Razor IMU трекера ([Arduino](http://ali.pub/1lltzk) + [GY-85](http://ali.pub/1lltk0) + Razor IMU firmware).

При старте приложения запускается GoPro VR Player (необходимо изменить путь до программы в файле "Setup.ini", также необходимо изменить номер com-порта). Приложение работает в фоне и закрывается после выхода из GoPro VR Player. Центрировать (сбросить) позицию можно с помощью кнопки "NumPad 5".

## Razor IMU SteamVR

Приложение для отслеживания вращения головы, в SteamVR ([с драйвером](https://github.com/r57zone/OpenVR-OpenTrack)), с помощью Arduino Razor IMU трекера ([Arduino](http://ali.pub/1lltzk) + [GY-85](http://ali.pub/1lltk0) + Razor IMU firmware).

Центрировать (сбросить) позицию можно с помощью кнопки "NumPad 5".

## Настройка GoPro VR Player
1. File -> Preferences. 
2. General settings -> Output display - Split screen.
3. Master / Slave -> Communication mode - Slave.

## Загрузка
>Версия для Windows XP, 7, 8.1, 10.<br>
**[Загрузить](https://github.com/r57zone/VR-tracking-apps/releases)**<br>

## Обратная связь
`r57zone[собака]gmail.com`

# (En) VR tracking apps


## GoPro VR Player OpenTrack
App for tracking the rotation of the head, in Gopro VR Player, with any [OpenTrack](https://github.com/opentrack/opentrack/releases/) tracker. 

**Setup**
1. Download, install and configure OpenTrack (add a hotkey to reset the alignment, adjust the sensitivity, change the output interface to "UDP over network" and set the IP "127.0.0.1" in the output interface settings).
2. Run the program.

## Razor IMU GoPro VR Player
App for tracking the rotation of the head, in GoPro VR Player, with Arduino Razor IMU tracker ([Arduino](http://ali.pub/1lltzk) + [GY-85](http://ali.pub/1lltk0) + Razor IMU firmware).

When the app starts, it launches GoPro VR Player (it is necessary to change the path to the program in the "Setup.ini" file, also it is necessary to change the com-port number). Application working in background mode and closes after exiting GoPro VR Player. You can center (reset) the position using the "NumPad 5" button.

## Razor IMU SteamVR

Application for tracking the rotation of the head, on SteamVR ([driver](https://github.com/r57zone/OpenVR-OpenTrack)), with Arduino Razor IMU tracker ([Arduino](http://ali.pub/1lltzk) + [GY-85](http://ali.pub/1lltk0) + Razor IMU firmware).

Center (reset) the position using the "NumPad 5" button.

## Setup GoPro VR Player
1. File -> Preferences. 
2. General settings -> Output display - Split screen.
3. Master / Slave -> Communication mode - Slave.

## Download
>Version for Windows XP, 7, 8.1, 10.<br>
**[Download](https://github.com/r57zone/VR-tracking-apps/releases)**<br>

## Feedback
`r57zone[at]gmail.com`