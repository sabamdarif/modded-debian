#!/data/data/com.termux/files/usr/bin/bash
R="$(printf '\033[1;31m')"                           
G="$(printf '\033[1;32m')"
Y="$(printf '\033[1;33m')"
B="$(printf '\033[1;34m')"
C="$(printf '\033[1;36m')"                                        W="$(printf '\033[1;37m')"

banner() {
clear

}



check_pack() {
	banner
	echo -e "${R} [${W}-${R}]${C} Checking required packages..."${W}
if [[ `command -v pulseaudio` && `command -v proot-distro` && `command -v wget` ]]; then
        echo -e "\n${R} [${W}-${R}]${G} Packages already installed."${W}
    else
        packs=(pulseaudio proot proot-distro)
        for hulu in "${packs[@]}"; do
            type -p "$hulu" &>/dev/null || {
                echo -e "\n${R} [${W}-${R}]${G} Installing package : ${Y}$hulu${C}"${W}
                pkg update -y
                pkg upgrade -y
                pkg install "$hulu" -y
            }
        done
    fi

}


install_rootfs() {
	banner
	echo -e "${R} [${W}-${R}]${C} Setting up Environment..."${W}
    if [[ -d "$PREFIX/var/lib/proot-distro/installed-rootfs/debian" ]]; then
        echo -e "\n${R} [${W}-${R}]${G} Distro already installed."${W}
        exit 0
    else
        proot-distro install debian
        termux-reload-settings
    fi

    if [[ -d "$PREFIX/var/lib/proot-distro/installed-rootfs/debian" ]]; then
        echo -e "\n${R} [${W}-${R}]${G} Installed Successfully !!"${W}
    else
        echo -e "\n${R} [${W}-${R}]${G} Error Installing Distro !\n"${W}
        exit 0
    fi
}

add_sound() {
    banner
    echo -e "\n${R} [${W}-${R}]${C} Fixing Sound Problem..."${W}
    if [[ ! -e "$HOME/.sound" ]]; then
        touch $HOME/.sound
    fi

    echo "pulseaudio --start --exit-idle-time=-1" >> $HOME/.sound
    echo "pacmd load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" >> $HOME/.sound
    if [[ -e "$PREFIX/var/lib/proot-distro/installed-rootfs/debian /root/gui.sh" ]]; then
        chmod +x $PREFIX/var/lib/proot-distro/installed-rootfs/debian/root/gui.sh
    else
        mv -f /data/data/com.termux/files/home/modded-debian/builder/gui.sh $PREFIX/var/lib/proot-distro/installed-rootfs/debian/root/gui.sh
        chmod +x $PREFIX/var/lib/proot-distro/installed-rootfs/debian/root/gui.sh
    fi

}

notes() {
	echo "proot-distro login debian --bind /dev/null:/proc/sys/kernel/cap_last_cap" > $PREFIX/bin/debian
    if [[ -e "$PREFIX/bin/debian" ]]; then
        chmod +x $PREFIX/bin/debian
        termux-reload-settings
	echo -e "\n${R} [${W}-${R}]${G} debian-letest(CLI) is now Installed on your Termux"${W}
        echo -e "\n${R} [${W}-${R}]${G} Type ${C}debian${G} to run debian CLI."${W}
        echo -e "\n${R} [${W}-${R}]${G} If you Want to Use debian in GUI MODE then ,"${W}
        echo -e "\n${R} [${W}-${R}]${G} Run ${C}debian${G} first & then type ${C}bash gui.sh "${W}
        echo -e "\n"
        exit 0
    else
        echo -e "\n${R} [${W}-${R}]${G} Error Installing Distro !"${W}
        exit 0
    fi
}



check_pack
install_rootfs
add_sound
notes
