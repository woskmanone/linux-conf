#!/bin/bash

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo "Please run as root"
    exit
fi

echo "--- 1. Optimizing DNF ---"
echo 'max_parallel_downloads=10' >> /etc/dnf/dnf.conf
echo 'defaultyes=True' >> /etc/dnf/dnf.conf

echo "--- 2. Updating System ---"
dnf upgrade --refresh -y

echo "--- 3. Installing RPM Fusion Repos ---"
dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
            https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y

echo "--- 4. Installing Intel Drivers & Codecs ---"
# intel-media-driver is for Broadwell+ (Gen8+), libva-intel-driver is for older
dnf install intel-media-driver libva-intel-driver -y
dnf groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin -y
dnf groupupdate sound-and-video -y

echo "--- 5. Installing Basic Tools (Git, Vim, Htop, Fastfetch) ---"
dnf install git vim htop fastfetch curl wget -y

echo "--- 6. Cleanup ---"
dnf autoremove -y
dnf clean all

echo "--- Setup Complete. Reboot recommended. ---"
