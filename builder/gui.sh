#!/bin/bash

R="$(printf '\033[1;31m')"
G="$(printf '\033[1;32m')"
Y="$(printf '\033[1;33m')"
W="$(printf '\033[1;37m')"
C="$(printf '\033[1;36m')"

banner() {
clear
printf "\033[32m code by @saba_mdrif \033[0m\n"
printf "\033[32m subscribe my YouTube Channel Hello Android \033[0m\n"

}

add_user() {
	  apt autoremove sudo -y
    banner
    read -p $' \e[1;31m[\e[0m\e[1;77m~\e[0m\e[1;31m]\e[0m\e[1;92m Input Username [Lowercase] : \e[0m\e[1;96m\en' user
    echo -e "${W}"
    read -p $' \e[1;31m[\e[0m\e[1;77m~\e[0m\e[1;31m]\e[0m\e[1;92m Input Password : \e[0m\e[1;96m\en' pass
    echo -e "${W}"
    useradd -m -s $(which bash) ${user}
    echo "${user}:${pass}" | chpasswd
    apt update -y
    apt install sudo -y
    echo "$user ALL=(ALL:ALL) ALL" >> /etc/sudoers
    cat <<EOF > "/data/data/com.termux/files/usr/bin/debian"
if [ "\$1" = "-r" ]; then
    proot-distro login debian
else
    proot-distro login --user "$user" debian
fi
EOF
    #chmod +x /data/data/com.termux/files/usr/bin/debian
    clear

}

update_sys() {
  echo "${G}Updating System..."${W}
  termux-wake-lock
  sleep 3
  apt-get update
}

ask() {
  banner
	echo
	echo -e "${R} [${W}-${R}]${C} Select Desktop Type"${W}
	echo
	echo "${C}1. XFCE4 (recommended)"${W}
	echo
	echo "${C}2. LXDE"${W}
	echo
	echo "${C}3. LXQT"${W}
	echo
	echo "${C}4. KDE"${W}
	echo
	echo "${C}5. GNOME"${W}
	echo
	read -p "${Y}Select option(default 1): "${W} select_desktop
	echo
  sleep 0.5
  banner
  read -p "${G}Do you to install VLC (y/n) "${w} ask_vlc
  sleep 0.5
  echo -e "${R} [${W}-${R}]${C} Select Browser"${W}
	echo
	echo "${C}1. Firefox (recommended)"${W}
	echo
	echo "${C}2. Chromium"${W}
	echo
	read -p "${Y}Select option(default 1): "${W} ask_browser
}

install_desktop_type() {
	banner
	if [[ $select_desktop == "1" ]]; then
		xfce_mode
	elif [[ $select_desktop == "2" ]]; then
		lxde_mode
	elif [[ $select_desktop == "3" ]]; then
		lxqt_mode
	elif [[ $select_desktop == "4" ]]; then
		kde_mode
	elif [[ $select_desktop == "5" ]]; then
		gnome_mode
	elif [[ $select_desktop == "" ]]; then
		xfce_mode
	fi
}

fix_broken() {
    banner
    echo -e "${Y}Checking error and fix it..."${W}
     dpkg --configure -a
     apt-get install --fix-broken -y
}

package() {
  banner
    echo -e "${R} [${W}-${R}]${C} Checking required packages..."${W}
    apt update -y
    apt --fix-broken install udisks2 -y
    rm /var/lib/dpkg/info/udisks2.postinst
    echo "" > /var/lib/dpkg/info/udisks2.postinst
     dpkg --configure -a
     apt-mark hold udisks2
     apt-mark unhold gvfs-daemons
     dpkg --configure -a
    packs=(sudo wget curl nano git mousepad librsvg2-common inetutils-tools dialog tightvncserver tigervnc-standalone-server tigervnc-tools dbus-x11 )
     dpkg --configure -a
    for packs_name in "${packs[@]}"; do
        type -p "$packs_name" &>/dev/null || {
            echo -e "\n${R} [${W}-${R}]${G} Installing package : ${Y}$packs_name${C}"${W}
             apt-get install "$packs_name" -y --no-install-recommends
        }
    done
    fix_broken
}

firefox_installer() {
    echo "${Y}Checking if  Firefox browser installed already.."${W}
		echo
		echo
		if [[ $(command -v firefox) ]]; then
			echo "${C}Firefox is already installed.."${W}
			sleep 0.5
			clear
		else
			clear
			echo "${G}Firefox not found.Installing now.."${W}
			echo
			echo
       apt install firefox-esr -y 
		fi
}

chromium_installer() {
  echo "${Y}Checking if  Chromium browser installed already.."${W}
		echo
		echo
		if [[ $(command -v chromium) ]]; then
			echo "${C}Chromium is already installed.."${W}
			sleep 0.5
			clear
		else
			clear
			echo "${G}Chromium not found.Installing now.."${W}
			echo
			echo
       apt install chromium -y 
		fi
}

browser_installer() {
		banner
    if [[$ask_browser == "1"]]; then
    firefox_installer
    elif [[$ask_browser == "2"]]; then 
    chromium_installer
    elif [[$ask_browser == ""]]; then
    firefox_installer
    fi
    
}
	
vlc_installer() {
	banner
if [ "$ask_vlc" == "y" ]; then
	echo "${Y}Checking if vlc is available or not"${W}
	if [[ $(command -v vlc) ]]; then
		echo
		echo "${G}vlc is already Installed"${W}
		sleep 1
	else
		echo "${G}vlc  is not installed. Installing vlc.."${W}
		echo
		sleep 1
    apt install vlc -y
	fi
else
    echo "${C}Canceling...."${W}
    sleep 1.2
fi
}

vncstop() {
 if [[ -e "/bin/vncstop" ]]; then
        rm -rf /bin/vncstop
    fi
    cat <<EOF > "/bin/vncstop"
#!/usr/bin/env bash
if [ "\$1" == "-f" ]; then
    pkill Xtigervnc
else
    vncserver -kill :*
fi
rm -rf /username/.vnc/localhost:*.pid
rm -rf /tmp/.X1-lock
rm -rf /tmp/.X11-unix/X1
EOF
chmod +x /bin/vncstop
}

xfce_mode() {
  add_user
  package
  banner
	echo -e "${R} [${W}-${R}]${C} Installing XFCE DESKTOP"${W}
        apt install xfce4* -y
       banner
       echo -e "${R} [${W}-${R}]${C} Setting up VNC Server..."${W}
  if [[ ! -d "$HOME/.vnc" ]]; then
        mkdir -p "$HOME/.vnc"
    fi
   if [[ -e "/bin/vncstart" ]]; then
        rm -rf /bin/vncstart
    fi                                                                       
    echo "#!/usr/bin/env bash" >>/bin/vncstart
  echo "dbus-launch" >>/bin/vncstart
  echo "vncserver -geometry 1500x720  -xstartup /usr/bin/startxfce4" >>/bin/vncstart
  chmod +x /bin/vncstart
  vncstop
    echo "export DISPLAY=":1"" >> /etc/profile
    echo "export PULSE_SERVER=127.0.0.1" >> /etc/profile
    source /etc/profile
}

gnome_mode() {
	banner
  echo "${G}Select Gnome Desktop Type..."${W}
	echo
	echo "${Y}1. Core (~2Gb | Recomended)"${W}
	echo
	echo "${Y}2. Full (~3.5GB of space)"${W}
	echo
	read -p "${Y}select an option (Default 1): "${W} answer_gnome_desktop
	echo
  if [[ ${answer_gnome_desktop} == "1" ]]; then
  banner
        echo "${G}Installing Gnome Core..."${W}
        echo
        apt install gnome-shell gnome-terminal -y
    elif [[ ${answer_gnome_desktop} == "2" ]]; then
    banner
        echo "${G}Installing Gnome Full..."${W}
        echo
        apt-get install gnome -y
    elif [[ ${answer_gnome_desktop} == "" ]]; then
    banner
        echo "${G}Installing Gnome Core..."${W}
        echo
        apt install gnome-shell gnome-terminal -y
    fi
	dpkg --configure -a
	apt --fix-broken install -y
  banner
  echo "${Y}Installing Required Packages"${W}
	packs=(wget curl nautilus nano gedit gnome-software gnome-tweaks gnome-shell-extension-manager tigervnc-standalone-server tigervnc-tools dbus-x11 )
	for packs_name in "${packs[@]}"; do
        type -p "$packs_name" &>/dev/null || {
            echo -e "\n${R} [${W}-${R}]${G} Installing package : ${Y}$packs_name${C}"${W}
             apt-get install "$packs_name" -y --no-install-recommends
        }
    done
    echo -e "${R} [${W}-${R}]${C} Setting up VNC Server..."${W}
 if [[ ! -d "$HOME/.vnc" ]]; then
    mkdir -p "$HOME/.vnc"
fi
if [[ -e "$HOME/.vnc/xstartup" ]]; then
    rm "$HOME/.vnc/xstartup"
fi
cat <<EOF > "$HOME/.vnc/xstartup"
export XDG_CURRENT_DESKTOP="GNOME"
service dbus start
gnome-shell --x11    
EOF
chmod +x "$HOME/.vnc/xstartup"
# mkdir -p "/home/$user/.vnc"
# cp -r "$HOME/.vnc/xstartup" "/home/$user/.vnc/xstartup"
# chmod +x "/home/$user/.vnc/xstartup"
   if [[ -e "/bin/vncstart" ]]; then
        rm -rf /bin/vncstart
    fi
  echo "#!/usr/bin/env bash" >>/bin/vncstart
  echo "vncserver -geometry 2580x1080 " >>/bin/vncstart
    chmod +x /bin/vncstart
  vncstop
  #echo "export DISPLAY=":1"" >> /etc/profile
    echo "export PULSE_SERVER=127.0.0.1" >> /etc/profile
    source /etc/profile
 echo -e "${R} [${W}-${R}]${C} Fix Vnc Login Issue.."${W}
   for file in $(find /usr -type f -iname "*login1*"); do rm -rf $file
   done
   echo "proot-distro login debian" > /data/data/com.termux/files/usr/bin/debian
}

lxde_mode() {
  add_user
  package
  banner
	echo -e "${R} [${W}-${R}]${C} Installing LXDE DESKTOP"${W}
	 apt install lxde lxterminal -y
	apt-get install udisks2 -y
	echo " " > /var/lib/dpkg/info/udisks2.postinst
	apt-mark hold udisks2
	apt-get install  tzdata -y
	apt-get install lxde lxterminal -y
	mv /usr/bin/lxpolkit /usr/bin/lxpolkit.bak
	apt-get --fix-broken install -y
	apt-get clean
	banner
	echo -e "${R} [${W}-${R}]${C} Setting up VNC Server..."${W}
  if [[ ! -d "$HOME/.vnc" ]]; then
        mkdir -p "$HOME/.vnc"
    fi
 if [[ -e "/bin/vncstart" ]]; then
        rm -rf /bin/vncstart
    fi
  echo "#!/usr/bin/env bash" >>/bin/vncstart
  echo "dbus-launch" >>/bin/vncstart
  echo "vncserver -geometry 1600x900 -name remote-desktop :1" >>/bin/vncstart
    chmod +x /bin/vncstart
  vncstop
    echo "export DISPLAY=":1"" >> /etc/profile
    echo "export PULSE_SERVER=127.0.0.1" >> /etc/profile
    source /etc/profile
}

lxqt_mode(){
  add_user
  package
  banner
	echo -e "${R} [${W}-${R}]${C} Installing LXQT DESKTOP"${W}
	apt-get install udisks2 -y
	echo " " > /var/lib/dpkg/info/udisks2.postinst
	apt-mark hold udisks2
	apt-get install  tzdata -y
	apt-get install lxqt qterminal -y
	apt-get install tigervnc-standalone-server dbus-x11 -y
	apt-get --fix-broken install -y
	apt-get clean
	 banner
       echo -e "${R} [${W}-${R}]${C} Setting up VNC Server..."${W}
  if [[ ! -d "$HOME/.vnc" ]]; then
        mkdir -p "$HOME/.vnc"
    fi
if [[ -e "/bin/vncstart" ]]; then
        rm -rf /bin/vncstart
    fi
  echo "#!/usr/bin/env bash" >>/bin/vncstart
  echo "dbus-launch" >>/bin/vncstart
  echo "vncserver -geometry 1600x900 -xstartup /bin/startlxqt" >>/bin/vncstart
    chmod +x /bin/vncstart
  vncstop
    echo "export DISPLAY=":1"" >> /etc/profile
    echo "export PULSE_SERVER=127.0.0.1" >> /etc/profile
    source /etc/profile
}

kde_mode() {
  add_user
  package
  banner
	echo -e "${R} [${W}-${R}]${C} Installing KDE DESKTOP"${W}
	apt-get install udisks2 -y
	echo " " > /var/lib/dpkg/info/udisks2.postinst
	apt-mark hold udisks2
	apt-get install tzdata -y
	apt-get install kde-plasma-desktop konsole -y
	apt-get install tigervnc-standalone-server dbus-x11 -y
	apt-get --fix-broken install -y
	apt-get clean
	 banner
       echo -e "${R} [${W}-${R}]${C} Setting up VNC Server..."${W}
  if [[ ! -d "$HOME/.vnc" ]]; then
        mkdir -p "$HOME/.vnc"
    fi
   if [[ -e "/bin/vncstart" ]]; then
        rm -rf /bin/vncstart
    fi
    echo "#!/usr/bin/env bash" >>/bin/vncstart
  echo "dbus-launch" >>/bin/vncstart
  echo "vncserver -geometry 1600x900 -xstartup /bin/startplasma-x11" >>/bin/vncstart
  chmod +x /bin/vncstart
   vncstop
    echo "export DISPLAY=":1"" >> /etc/profile
    echo "export PULSE_SERVER=127.0.0.1" >> /etc/profile
    source /etc/profile
}

note() {
banner
    echo -e " ${G} Successfully Installed !"${W}
    termux-wake-unlock
    sleep 1
    if [[ $select_desktop == "5" ]]; then
    echo
    echo -e " ${C}Type ${G}debian${C} to login into debian cli (as root user)"${W}
    echo
    echo -e " ${C}You cannot add any user in GNOME Desktop"${W}
    echo
    echo -e " ${C}You need to use as root user"${W}
    else
    echo
    echo -e " ${C}Type ${G}debian${C} to login as normal user"${W}
    echo
    echo -e " ${C}Type ${G}debian -r${C} to login as root user"${W}
    echo
    fi
    echo
    echo -e " ${C}Type ${G}vncstart${C} to run Vncserver."${W}
    echo
    echo -e " ${C}Type ${G}vncstop${C} to stop Vncserver."${W}
    echo
    echo -e " ${C}Open VNC VIEWER or Nethunter Kex & Click on + Button."${W}
    echo
    echo -e " ${C}Enter the Address localhost:1 & Name anything you like."${W}
    echo
    echo -e " ${C}Click on Connect & Input the Password."${W}
    echo 
    echo -e " ${C}If you install the GNOME DESKKTOP you may need to use UltraVnc mode in Nethunter Kex."${W}
    echo
    echo -e " ${C}Enjoy"${W}
    echo
    echo

}

add_sound() {
	echo "$(echo "bash ~/.sound" | cat - /data/data/com.termux/files/usr/bin/debian)" > /data/data/com.termux/files/usr/bin/debian
}

checkup_xfce() {
  if [[ $select_desktop == "1" ]]; then
    echo "${Y}Do you want to set up the application menu?"${W}
    customize
  else
    echo "Canceling..."
    sleep 0.5
  fi
}


customize() {
	if [[ $(command -v plank) ]]; then
	echo "${G}Plank is already installed .."${W}
        sleep .5 
        clear
   else
	   clear
	   sleep 1 
	   echo "${G}Plank not found.Installing now.."${W}
	   echo 
	    apt install plank -y
	fi
mkdir /home/${user}/.config/autostart/
        cat <<EOF > "/home/${user}/.config/autostart/plank.desktop"
[Desktop Entry]
Type=Application
Name=Plank
Exec=plank
EOF
chmod +x /home/${user}/.config/autostart/plank.desktop
 echo "${G}Create Your VNC Password"${W}
    vncstart
    sleep 60
    check-up
    vncstop
  gsettings set net.launchpad.plank.dock.settings:/net/launchpad/plank/docks/dock1/ theme 'Gtk+'
	gsettings set net.launchpad.plank.dock.settings:/net/launchpad/plank/docks/dock1/ zoom-enabled true
  banner
	sudo apt install rofi -y
	sudo apt install wget -y
	mkdir -p ~/.config/rofi
        rofi -dump-config > ~/.config/rofi/config.rasi
	cd ~
	wget https://raw.githubusercontent.com/sabamdarif/modded-debian/main/images/application-menu.png
	wget https://raw.githubusercontent.com/sabamdarif/modded-debian/main/builder/style.rasi
	mv style.rasi application-menu.png ~/.config/rofi
cat <<EOF > "/home/${user}/.config/rofi/launcher.sh"
#!/usr/bin/env bash

	## Run
	rofi \
    -show drun \
    -theme /home/${user}/.config/rofi/style.rasi
EOF
cat <<EOF > "appsearch.desktop"
[Desktop Entry]
Name=Application Search
Exec=bash /home/${user}/.config/rofi/launcher.sh
Icon=/home/${user}/.config/rofi/application-menu.png
Type=Application
Terminal=false
StartupNotify=false
EOF
mkdir ~/.local/share/applications
if [[ ! -d "~/.local/share/applications" ]]; then
    mkdir ~/.local/share/applications
fi
mv appsearch.desktop ~/.local/share/applications/
chmod +x ~/.local/share/applications/appsearch.desktop
config_folder="/home/${user}/.config"
plank_folder="${config_folder}/plank"
dock_folder="${plank_folder}/dock1"
launchers_folder="${dock_folder}/launchers"
if [ ! -d "${config_folder}" ]; then
    mkdir -p "${config_folder}"
fi

if [ ! -d "${plank_folder}" ]; then
    mkdir -p "${plank_folder}"
fi

if [ ! -d "${dock_folder}" ]; then
    mkdir -p "${dock_folder}"
fi

if [ ! -d "${launchers_folder}" ]; then
    mkdir -p "${launchers_folder}"
fi
cd ~
cat <<EOF > appsearch.dockitem
[PlankDockItemPreferences]
Launcher=file:///home/${user}/.local/share/applications/appsearch.desktop
EOF
mv appsearch.dockitem ~/.config/plank/dock1/launchers
clear
killall plank

}

ask
update_sys
install_desktop_type
browser_installer
vlc_installer
add_sound
checkup_xfce
note