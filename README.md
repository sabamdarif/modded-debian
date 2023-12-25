
<p align="center"><b>Easily Install Full Debian Linux Verious Type Of Desktop in Termux</b></p>

<div align="center">
   
![GitHub Repo stars](https://img.shields.io/github/stars/sabamdarif/modded-debian)
![GitHub issues](https://img.shields.io/github/issues/sabamdarif/modded-debian)
![GitHub License](https://img.shields.io/github/license/sabamdarif/modded-debian)
</div>

### Features:

- :speaker: Fixed Audio Output
- :computer:GNOME work perfectly
- :globe_with_meridians: 2 Browsers (Chromium & Mozilla Firefox)
- :tv: VLC Media Player and MPV media player / Pre installed SOFTWARE-STORE (IN GNOME)
- :books: Easy for Beginners
- :computer: Add new Application Menu
- :hammer: Install XFCE, LXDE, LXQT, KDE, or GNOME Desktop

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
- **Type `vncstop -f` to stop Vncserver forcefully**
- **Type `bash remove.sh` to remove DEBIAN**

### ISSUES:
- **Issue:-** Vnc server related issue like *vnc autostop* , *Apps not showing*
- **Solution:-** Login into root user using `kali -r` then launch vncserver

### If you like my work then dont forget to give a Star :)
