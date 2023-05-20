
<p align="center"><b>Easily Install Full Debian Linux Verious Type Of Desktop in Termux</b></p>

<div align="center">

[![GitHub stars](https://img.shields.io/github/stars/sabamdarif/modded-debian)](https://github.com/sabamdarif/modded-debian/stargazers)
[![GitHub issues](https://img.shields.io/github/issues/sabamdarif/modded-debian)](https://github.com/sabamdarif/modded-debian/issues)
[![GitHub license](https://img.shields.io/github/license/sabamdarif/modded-debian)](https://github.com/sabamdarif/modded-debian/blob/main/LICENSE)

</div>

### Features:

- :speaker: Fixed Audio Output
- :computer:GNOME work perfectly
- :globe_with_meridians: 2 Browsers (Chromium & Mozilla Firefox)
- :tv: VLC Media Player and MPV media player / Pre installed SOFTWARE-STORE (IN GNOME)
- :books: Easy for Beginners
- :computer: Add new Application Menu
- :hammer: Install XFCE, LXDE, LXQT, KDE, or GNOME Desktop
- :art: More customization (new styles added and new fonts etc...)

### Installation:

1. Firstly install [Termux](https://termux.com) apk from [HERE](https://f-droid.org/repo/com.termux_118.apk)
2. Secondly Clone the Repository & Run the setup File

   - `pkg update -y && pkg upgrade -y`
   - `pkg install git wget -y`
   - `git clone https://github.com/sabamdarif/modded-debian`
   - `cd modded-debian`
   - `bash setup.sh`
   - `debian`
   - `bash gui.sh`
   - Now select **KFCE**, **KDE**, **LXDE**, **LXQT** OR **GNOME** Desktop (any one)





3. **You have to note your VNC password !!**
4. DEBIAN image is now successfully installed.

   - Type `vncstart` to run Vncserver
   - Type `vncstop` to stop Vncserver

5. Install VNC VIEWER Apk on your Device. [Google Play Store](https://play.google.com/store/apps/details?id=com.realvnc.viewer.android&hl=en)
6. Or, Install NetHunter KeX from [Nethunter Store](https://store.nethunter.com/en/packages/com.offsec.nethunter.kex/)

7. Open VNC VIEWER & Click on + Button & Enter the Address `localhost:1` & Name anything you like
8. Set the Picture Quality to High for better Quality
9. Click on Connect & Input the Password
10. Enjoy :smile:

### NOTE:

- **Type `debian` to run DEBIAN CLI AS NORMAL USER.**
- **Type `debian -r` to run DEBIAN CLI AS ROOT USER.**
- **Type `vncstart` to run Vncserver**
- **Type `vncstop` to stop Vncserver**
- **Type `fixvnc` if the vnc server not started (for Android 12 users)**
- **Type `bash remove.sh` to remove DEBIAN**

### ISSUES:
- **Issue:-** Android 12 users have a problem of vncserver automatically stop and and show " [Process completed (signal 9) - press Enter] " &  the next time vncserver not starting

- **Solution:-** *use command `fixvnc` and the server started again*

### If you like our work then dont forget to give a Star :)

