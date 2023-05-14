#!/data/data/com.termux/files/usr/bin/bash

R="$(printf '\033[1;31m')"                                        
G="$(printf '\033[1;32m')"
Y="$(printf '\033[1;33m')"
B="$(printf '\033[1;34m')"
C="$(printf '\033[1;36m')"
W="$(printf '\033[1;37m')"

banner() {
clear

}

remove() {
    echo -e "${R} [${W}-${R}]${C} Purging packages..."${W}
    if [[ -d "$PREFIX/var/lib/proot-distro/installed-rootfs/debian" ]]; then
        proot-distro remove debian 
		#proot-distro clear-cache
    rm -rf $PREFIX/bin/debian
    cd ~
    rm .sound
    rm -rf /data/data/com.termux/files/usr/bin/debian
    rm -rf $PREFIX/var/lib/proot-distro/installed-rootfs/debian
        exit 0
    fi
}

banner
remove
