#!/bin/bash

R="$(printf '\033[1;31m')"
G="$(printf '\033[1;32m')"
Y="$(printf '\033[1;33m')"
W="$(printf '\033[1;37m')"
C="$(printf '\033[1;36m')"

banner() {
clear

}


package() {
	banner
    echo -e "${R} [${W}-${R}]${C} Checking required packages..."${W}
    apt update -y
    apt install sudo -y
    apt --fix-broken install udisks2 -y
    rm /var/lib/dpkg/info/udisks2.postinst
    echo "" > /var/lib/dpkg/info/udisks2.postinst
    sudo dpkg --configure -a
    sudo apt-mark hold udisks2
    sudo apt-mark unhold gvfs-daemons
    sudo dpkg --configure -a
    packs=(sudo wget curl nano git qterminal mousepad librsvg2-common inetutils-tools dialog tightvncserver tigervnc-standalone-server tigervnc-tools dbus-x11 )
    sudo dpkg --configure -a
    for hulu in "${packs[@]}"; do
        type -p "$hulu" &>/dev/null || {
            echo -e "\n${R} [${W}-${R}]${G} Installing package : ${Y}$hulu${C}"${W}
            sudo apt-get install "$hulu" -y --no-install-recommends
        }
    done
    sudo apt update -y
}

add_user() {
    banner
    apt update 
    apt install sudo -y
    read -p $' \e[1;31m[\e[0m\e[1;77m~\e[0m\e[1;31m]\e[0m\e[1;92m Input Username [Lowercase] : \e[0m\e[1;96m\en' user
    echo -e "${W}"
    read -p $' \e[1;31m[\e[0m\e[1;77m~\e[0m\e[1;31m]\e[0m\e[1;92m Input Password : \e[0m\e[1;96m\en' pass
    echo -e "${W}"
    useradd -m -s $(which bash) ${user}
    echo "${user}:${pass}" | chpasswd
    echo "$user ALL=(ALL:ALL) ALL" >> /etc/sudoers

cat << EOF > /data/data/com.termux/files/usr/bin/debian
#!/bin/bash
bash ~/.sound
if [ "$1" = "-r" ]; then
  proot-distro login debian --bind /dev/null:/proc/sys/kernel/cap_last_cap
else
  proot-distro login --user $user debian --bind /dev/null:/proc/sys/kernel/cap_last_cap
fi

EOF

    #chmod +x /data/data/com.termux/files/usr/bin/debian
    clear

}

firefox_install() {
		clear
		banner
		sleep 1
		echo "${Y}Checking if  Firefox browser installed already.."${W}
		echo
		echo
		if [[ $(command -v firefox) ]]; then
			echo "${C}Firefox is already installed.."${W}
			sleep .5
			clear
		else
			clear
			sleep 1
			echo "${G}Firefox not found.Installing now.."${W}
			echo
			echo
			sudo apt update;sudo apt install firefox-esr -y 
		fi

}
	
vlc_installer() {

	clear
	banner
	echo
	echo "${Y}Checking if vlc is available or not"${W}
	if [[ $(command -v vlc) ]]; then
		echo 
		echo "${G}vlc is already Installed"${W}
		sleep 1
	else
		echo "${G}vlc  is not installed. Installing vlc.."${W}
		echo
		sleep 1
		sudo apt update && sudo apt install vlc -y
	fi

}

select_desktop_type() {
	clear
	banner
	echo
	echo -e "${R} [${W}-${R}]${C} Select Desktop Type"${W}
	echo
	echo "${C}1. XFCE4"${W}
	echo
	echo "${C}2. LXDE"${W}
	echo
	echo "${C}3. LXQT"${W}
	echo
	echo "${C}4. KDE"${W}
	echo
	echo "${C}5. GNOME"${W}
	echo
	read -p "${Y}Select option(default 1): "${W} select_method
	echo
	sleep 1.5

	if [[ $select_method == "1" ]]; then
		kfce_mode
	fi
	if [[ $select_method == "2" ]]; then
		lxde_mode
	fi
	if [[ $select_method == "3" ]]; then
		lxqt_mode
	fi
	if [[ $select_method == "4" ]]; then
		kde_mode
	fi
	if [[ $select_method == "5" ]]; then
		gnome_mode
	fi
	if [[ $select_method == "" ]]; then
		kfce_mode
	fi
}

kfce_mode() {
	add_user
	banner
	echo -e "${R} [${W}-${R}]${C} Installing XFCE DESKTOP"${W}
	apt update
       sudo apt install xfce4* -y
       banner
       echo -e "${R} [${W}-${R}]${C} Setting up VNC Server..."${W}
  if [[ ! -d "$HOME/.vnc" ]]; then
        mkdir -p "$HOME/.vnc"
    fi
   if [[ -e "/usr/local/bin/vncstart" ]]; then
        rm -rf /usr/local/bin/vncstart
    fi                                                                       
    echo "#!/usr/bin/env bash" >>/usr/local/bin/vncstart
  echo "dbus-launch" >>/usr/local/bin/vncstart
  echo "vncserver -geometry 1280x720  -xstartup /usr/bin/startxfce4" >>/usr/local/bin/vncstart
  chmod +x /usr/local/bin/vncstart
  if [[ -e "/usr/local/bin/vncstop" ]]; then
        rm -rf /usr/local/bin/vncstop
    fi
  echo "#!/usr/bin/env bash" >>/usr/local/bin/vncstop
  echo "vncserver -kill :*" >>/usr/local/bin/vncstop
  echo "rm -rf /username/.vnc/localhost:*.pid" >>/usr/local/bin/vncstop
  echo "rm -rf /tmp/.X1-lock" >>/usr/local/bin/vncstop
  echo "rm -rf /tmp/.X11-unix/X1" >>/usr/local/bin/vncstop
    chmod +x /usr/local/bin/vncstop
  if [[ -e "/usr/local/bin/fixvnc" ]]; then
        rm -rf /usr/local/bin/fixvnc
    fi
  echo "pkill Xtigervnc" >>/usr/local/bin/fixvnc
  echo "return \$?" >>/usr/local/bin/fixvnc
    chmod +x /usr/local/bin/fixvnc

    echo "export DISPLAY=":1"" >> /etc/profile
    echo "export PULSE_SERVER=127.0.0.1" >> /etc/profile
    source /etc/profile
    cd ~
    package
}

gnome_mode() {
	add_user
	banner
	echo -e "${R} [${W}-${R}]${C} Installing GNOME DESKTOP"${W}
	apt update
	apt install gnome gnome-shell gnome-tweaks gnome-terminal gnome-session gdm3 gnome-shell-extension-dashtodock gnome-software -y
	banner
   echo -e "${R} [${W}-${R}]${C} Setting up VNC Server..."${W}
   sudo apt install tigervnc-standalone-server dbus-x11 nano gedit -y
  if [[ ! -d "$HOME/.vnc" ]]; then
        mkdir -p "$HOME/.vnc"
    fi
   if [[ -e "/usr/local/bin/vncstart" ]]; then
        rm -rf /usr/local/bin/vncstart
    fi                                                                      

  echo "sudo service dbus start" >>/usr/local/bin/vncstart
  echo "vncserver -geometry 1280x720" >>/usr/local/bin/vncstart
    chmod +x /usr/local/bin/vncstart
  if [[ -e "/usr/local/bin/vncstop" ]]; then
        rm -rf /usr/local/bin/vncstop                                        
        fi
  
  echo "vncserver -kill :*" >>/usr/local/bin/vncstop
  echo "rm -rf /username/.vnc/localhost:*.pid" >>/usr/local/bin/vncstop
  echo "rm -rf /tmp/.X1-lock" >>/usr/local/bin/vncstop
  echo "rm -rf /tmp/.X11-unix/X1" >>/usr/local/bin/vncstop
    chmod +x /usr/local/bin/vncstop
  if [[ -e "/usr/local/bin/fixvnc" ]]; then
        rm -rf /usr/local/bin/fixvnc                                         
        fi
  echo "pkill Xtigervnc" >>/usr/local/bin/fixvnc
  echo "return \$?" >>/usr/local/bin/fixvnc
    chmod +x /usr/local/bin/fixvnc

    echo "export PULSE_SERVER=127.0.0.1" >> /etc/profile
    source /etc/profile
    cat << EOF >> ~/.vnc/xstartup
#!/bin/sh
export XDG_CURRENT_DESKTOP="GNOME"
service dbus start
gnome-shell --x11
EOF
chmod +x ~/.vnc/xstartup
if [[ ! -d "/home/$user/.vnc" ]]; then                                                 mkdir -p "/home/$user/.vnc"
    fi
cat << EOF >> /home/$user/.vnc/xstartup
#!/bin/sh                                                                        export XDG_CURRENT_DESKTOP="GNOME"
service dbus start
gnome-shell --x11
EOF
chmod +x /home/$user/.vnc/xstartup
}

lxde_mode() {
	add_user
	banner
	echo -e "${R} [${W}-${R}]${C} Installing LXDE DESKTOP"${W}
	apt update
	sudo apt install lxde lxterminal debian-themes -y
	apt-get install udisks2 -y
	echo " " > /var/lib/dpkg/info/udisks2.postinst
	apt-mark hold udisks2
	apt-get install sudo tzdata -y
	apt-get install lxde lxterminal debian-themes -y
	mv /usr/bin/lxpolkit /usr/bin/lxpolkit.bak
	apt-get --fix-broken install -y
	apt-get clean
	banner
	echo -e "${R} [${W}-${R}]${C} Setting up VNC Server..."${W}
  if [[ ! -d "$HOME/.vnc" ]]; then
        mkdir -p "$HOME/.vnc"
    fi
   if [[ -e "/usr/local/bin/vncstart" ]]; then
        rm -rf /usr/local/bin/vncstart
    fi
    echo "#!/usr/bin/env bash" >>/usr/local/bin/vncstart
  echo "dbus-launch" >>/usr/local/bin/vncstart
  echo "vncserver -geometry 1280x720 -name remote-desktop :1" >>/usr/local/bin/vncstart
  chmod +x /usr/local/bin/vncstart
  if [[ -e "/usr/local/bin/vncstop" ]]; then
        rm -rf /usr/local/bin/vncstop
    fi
  echo "#!/usr/bin/env bash" >>/usr/local/bin/vncstop
  echo "vncserver -kill :*" >>/usr/local/bin/vncstop
  echo "rm -rf /username/.vnc/localhost:*.pid" >>/usr/local/bin/vncstop
  echo "rm -rf /tmp/.X1-lock" >>/usr/local/bin/vncstop
  echo "rm -rf /tmp/.X11-unix/X1" >>/usr/local/bin/vncstop
    chmod +x /usr/local/bin/vncstop
  if [[ -e "/usr/local/bin/fixvnc" ]]; then
        rm -rf /usr/local/bin/fixvnc
    fi
  echo "pkill Xtigervnc" >>/usr/local/bin/fixvnc
  echo "return \$?" >>/usr/local/bin/fixvnc
    chmod +x /usr/local/bin/fixvnc
    echo "export DISPLAY=":1"" >> /etc/profile
    echo "export PULSE_SERVER=127.0.0.1" >> /etc/profile
    source /etc/profile
    package
}

lxqt_mode(){
	add_user
	banner
	echo -e "${R} [${W}-${R}]${C} Installing LXQT DESKTOP"${W}
	apt-get update
	apt-get install udisks2 -y
	echo " " > /var/lib/dpkg/info/udisks2.postinst
	apt-mark hold udisks2
	apt-get install sudo tzdata -y
	apt-get install lxqt qterminal debian-themes -y
	apt-get install tigervnc-standalone-server dbus-x11 -y
	apt-get --fix-broken install -y
	apt-get clean
	 banner
       echo -e "${R} [${W}-${R}]${C} Setting up VNC Server..."${W}
  if [[ ! -d "$HOME/.vnc" ]]; then
        mkdir -p "$HOME/.vnc"
    fi
   if [[ -e "/usr/local/bin/vncstart" ]]; then
        rm -rf /usr/local/bin/vncstart
    fi
    echo "#!/usr/bin/env bash" >>/usr/local/bin/vncstart
  echo "dbus-launch" >>/usr/local/bin/vncstart
  echo "vncserver -geometry 1280x720 -xstartup /bin/startlxqt" >>/usr/local/bin/vncstart
  chmod +x /usr/local/bin/vncstart
  if [[ -e "/usr/local/bin/vncstop" ]]; then
        rm -rf /usr/local/bin/vncstop
    fi
  echo "#!/usr/bin/env bash" >>/usr/local/bin/vncstop
  echo "vncserver -kill :*" >>/usr/local/bin/vncstop
  echo "rm -rf /username/.vnc/localhost:*.pid" >>/usr/local/bin/vncstop
  echo "rm -rf /tmp/.X1-lock" >>/usr/local/bin/vncstop
  echo "rm -rf /tmp/.X11-unix/X1" >>/usr/local/bin/vncstop
    chmod +x /usr/local/bin/vncstop
  if [[ -e "/usr/local/bin/fixvnc" ]]; then
        rm -rf /usr/local/bin/fixvnc
    fi
  echo "pkill Xtigervnc" >>/usr/local/bin/fixvnc
  echo "return \$?" >>/usr/local/bin/fixvnc
    chmod +x /usr/local/bin/fixvnc

    echo "export DISPLAY=":1"" >> /etc/profile
    echo "export PULSE_SERVER=127.0.0.1" >> /etc/profile
    source /etc/profile
    package
}

kde_mode() {
	add_user
	banner
	echo -e "${R} [${W}-${R}]${C} Installing KDE DESKTOP"${W}
	apt update 
	apt-get install udisks2 -y
	echo " " > /var/lib/dpkg/info/udisks2.postinst
	apt-mark hold udisks2
	apt-get install sudo tzdata -y
	apt-get install kde-plasma-desktop konsole -y
	apt-get install tigervnc-standalone-server dbus-x11 -y
	apt-get --fix-broken install -y
	apt-get clean
	 banner
       echo -e "${R} [${W}-${R}]${C} Setting up VNC Server..."${W}
  if [[ ! -d "$HOME/.vnc" ]]; then
        mkdir -p "$HOME/.vnc"
    fi
   if [[ -e "/usr/local/bin/vncstart" ]]; then
        rm -rf /usr/local/bin/vncstart
    fi
    echo "#!/usr/bin/env bash" >>/usr/local/bin/vncstart
  echo "dbus-launch" >>/usr/local/bin/vncstart
  echo "vncserver -geometry 1280x720 -xstartup /bin/startplasma-x11" >>/usr/local/bin/vncstart
  chmod +x /usr/local/bin/vncstart
  if [[ -e "/usr/local/bin/vncstop" ]]; then
        rm -rf /usr/local/bin/vncstop
    fi
  echo "#!/usr/bin/env bash" >>/usr/local/bin/vncstop
  echo "vncserver -kill :*" >>/usr/local/bin/vncstop
  echo "rm -rf /username/.vnc/localhost:*.pid" >>/usr/local/bin/vncstop
  echo "rm -rf /tmp/.X1-lock" >>/usr/local/bin/vncstop
  echo "rm -rf /tmp/.X11-unix/X1" >>/usr/local/bin/vncstop
    chmod +x /usr/local/bin/vncstop
  if [[ -e "/usr/local/bin/fixvnc" ]]; then
        rm -rf /usr/local/bin/fixvnc
    fi
  echo "pkill Xtigervnc" >>/usr/local/bin/fixvnc
  echo "return \$?" >>/usr/local/bin/fixvnc
    chmod +x /usr/local/bin/fixvnc

    echo "export DISPLAY=":1"" >> /etc/profile
    echo "export PULSE_SERVER=127.0.0.1" >> /etc/profile
    source /etc/profile
    package

}

		

fix_broken() {
    banner
    echo -e "${Y}Checking error and fix it..."${W}
    sudo dpkg --configure -a
     
    sudo apt-get install --fix-broken keyboard-configuration -y
    rm ~/.bashrc
    cp /etc/skel/.bashrc ~
}


note() {
banner
    echo -e " ${G} Successfully Installed !"${W}
    sleep 1
    echo
    echo -e " ${G}Type ${C}vncstart${G} to run Vncserver."${W}
    echo
    echo -e " ${G}Type ${C}vncstop${G} to stop Vncserver."${W}
    echo
    echo -e " ${C}Install VNC VIEWER OR Nethunter Kex on your Device."${W}
    echo
    echo -e " ${C}Open VNC VIEWER & Click on + Button."${W}
    echo
    echo -e " ${C}Enter the Address localhost:1 & Name anything you like."${W}
    echo
    echo -e " ${C}Set the Picture Quality to High for better Quality."${W}
    echo 

    echo -e " ${C}Click on Connect & Input the Password."${W}
    echo 
    echo -e " ${C}Enjoy :D"${W}
    echo
    echo

}


clenup() {
	clear
    banner
	echo
	echo "Cleaning up system.."
	echo
    sleep 2
    cd ~
	sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
	sleep 2
	sudo dpkg --configure -a
	apt autoremove -y
	sudo apt autoremove xfce4-terminal -y
        sleep 2
    sudo apt clean && sudo apt autoclean
	
}

select_desktop_type
firefox_install
vlc_installer
clenup
fix_broken
note
