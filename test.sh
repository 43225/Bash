#!/bin/bash

#Create a variable for StaticJitterBugPair download URL
link="https://nightly.link/nythepegasus/StaticJitterbugPair/actions/runs/10828715664/jitterbugpair.zip"

# Function to install usbmuxd
install_usbmuxd() {
    case "$1" in
        "ubuntu" | "debian")
            sudo apt update -y && sudo apt upgrade -y
            sudo apt install -y usbmuxd libimobiledevice-utils unzip
			sudo apt autoremove
			wget "$link" && unzip jitterbugpair.zip
			chmod +x jitterbugpair
			usbmuxd
			./jitterbugpair
            ;;
        "fedora")
            sudo dnf upgrade --refresh -y
			sudo dnf install usbmuxd libimobiledevice-utils unzip -y
			sudo dnf autoremove
			usbmuxd
			wget "$link" && unzip jitterbugpair.zip
			chmod +x jitterbugpair
			./jitterbugpair
            ;;
        "arch")
            sudo pacman -Syu --noconfirm
			sudo  pacman -S usbmuxd libimobiledevice wget unzip  --noconfirm
			wget "$link" && unzip jitterbugpair.zip
			chmod +x jitterbugpair
			sudo systemctl start usbmuxd
			./jitterbugpair
            ;;
        "alpine")
            sudo apk update && sudo apk upgrade --no-cache -y
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
            sudo apt update
            sudo apt install -y usbmuxd
            ;;
		"void")
			xbps-install -Su libtool base-devel git openssl-devel wget gnutls pkg-config -y
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
esac