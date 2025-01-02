#!/bin/bash

#Create a variable for StaticJitterBugPair download URL
link="https://nightly.link/nythepegasus/StaticJitterbugPair/actions/runs/10828715664/jitterbugpair.zip"

# Function to install usbmuxd
install_usbmuxd() {
    case "$1" in
        "ubuntu" | "debian")
            sudo su
			apt-get update -y && sudo apt upgrade -y
            apt install -y usbmuxd libimobiledevice-utils unzip
			apt autoremove
			wget "$link" && unzip jitterbugpair.zip
			chmod +x jitterbugpair
			systemctl start usbmuxd.service
			./jitterbugpair
            ;;
        "fedora")
            sudo su
			dnf upgrade --refresh
			dnf install usbmuxd libimobiledevice-utils unzip -y
			dnf autoremove
			usbmuxd
			wget "$link" && unzip jitterbugpair.zip
			chmod +x jitterbugpair
			./jitterbugpair
            ;;
        "arch")
            sudo pacman -Syu --noconfirm
	    sudo su
			pacman -S usbmuxd libimobiledevice wget unzip  --noconfirm
			wget "$link" && unzip jitterbugpair.zip
			chmod +x jitterbugpair
			systemctl start usbmuxd
			./jitterbugpair
            ;;
        "alpine")
            sudo su
	    apk update && apk upgrade --no-cache -y
			apk add --no-cache build-base libtool automake autoconf pkgconfig
			git clone https://github.com/libimobiledevice-win32/libplist && cd libplist
			./autogen.sh --without-cython --prefix=/usr
			make && make install && make install DESTDIR=/out
			cd ~
			git clone https://github.com/libimobiledevice-win32/libusbmuxd && cd libusbmuxd
			./autogen.sh --without-cython --prefix=/usr
			make && make install && make install DESTDIR=/out
			cd ~
			git clone https://github.com/libimobiledevice-win32/libimobiledevice && cd libimobiledevice
			./autogen.sh --without-cython --prefix=/usr
			make && make install && make install DESTDIR=/out
			cd ~
			https://github.com/libimobiledevice-win32/usbmuxd && cd usbmuxd
			./autogen.sh --without-cython --prefix=/usr
			make && make install && make install DESTDIR=/out
			cd ~
			usbmuxd
			wget "$link" && unzip jitterbugpair.zip
			rm -rf jitterbugpair.zip
			chmod +x jitterbugpair
			./jitterbugpair
            ;;
        "linuxmint")
            sudo su
			apt-get update -y && sudo apt upgrade -y
            apt install -y usbmuxd libimobiledevice-utils unzip
			apt autoremove
			wget "$link" && unzip jitterbugpair.zip
			chmod +x jitterbugpair
			systemctl start usbmuxd.service
			./jitterbugpair
            ;;
		"void")
			xbps-install// -Su libtool base-devel git openssl-devel wget gnutls pkg-config -y
			git clone https://github.com/libimobiledevice/libplist && cd libplist
			./autogen.sh --without-cython --prefix=/usr
			make && make install && make install DESTDIR=/out
			cd ~
			git clone https://github.com/libimobiledevice/libusbmuxd && cd libusbmuxd
			./autogen.sh --without-cython --prefix=/usr
			make && make install && make install DESTDIR=/out
			cd ~
			git clone https://github.com/libimobiledevice/libimobiledevice && cd libimobiledevice
			./autogen.sh --without-cython --prefix=/usr
			make && make install && make install DESTDIR=/out
			cd ~
			https://github.com/libimobiledevice/usbmuxd && cd usbmuxd
			./autogen.sh --without-cython --prefix=/usr
			make && make install && make install DESTDIR=/out
			cd ~
			usbmuxd
			wget "$link" && unzip jitterbugpair.zip
			rm -rf jitterbugpair.zip
			chmod +x jitterbugpair
			./jitterbugpair
			;;
		"nixos")
			sudo su
			nix-shell -p usbmuxd libimobiledevice git wget unzip 
			wget "$link" && unzip jitterbugpair.zip
			chmod +x jitterbugpair
			usbmuxd
			./jitterbugpair
		
			
		*)
            echo "Unsupported distribution or unable to detect."
            exit 1
            ;;
    esac
}

# Detect the OS
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS_NAME=$ID
elif [ -f /etc/lsb-release ]; then
    . /etc/lsb-release
    OS_NAME=ubuntu
else
    echo "Could not detect OS."
    exit 1
fi

# Normalize the OS name
case "$OS_NAME" in
    ubuntu)
        install_usbmuxd "ubuntu"
        ;;
    debian)
        install_usbmuxd "debian"
        ;;
    fedora)
        install_usbmuxd "fedora"
        ;;
    arch)
        install_usbmuxd "arch"
        ;;
    alpine)
        install_usbmuxd "alpine"
        ;;
    linuxmint)
        install_usbmuxd "linuxmint"
        ;;
	void)
		install_usbmuxd "void"
		;;
	nixos)
		install_usbmuxd "nixos"
		;;
esac
