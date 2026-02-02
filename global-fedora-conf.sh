#!/bin/bash
if [ "$EUID" -ne 0 ]; then 
    echo "Please run as root"
    exit
fi
INSTALL_ZSH=true

echo 'max_parallel_downloads=10' >> /etc/dnf/dnf.conf
echo 'defaultyes=True' >> /etc/dnf/dnf.conf

echo "Updating system"
dnf upgrade --refresh -y
echo "Installing Repos"
sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf config-manager --set-enabled fedora-cisco-openh264
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

if [ "$INSTALL_ZSH" = true ]; then
    echo "--- [Shell] Installing Zsh ---"
    dnf install zsh -y
    # Note: Oh-My-Zsh usually requires user interaction, installed later by user
fi

echo "Installing Intel tools"
dnf install intel-media-driver libva-intel-driver -y
dnf groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin -y
dnf groupupdate sound-and-video -y

echo "Installing basic tools"
dnf install -y liberation-fonts fuse fuse-libs wget curl
wget https://www.google.com/intl/ru/chrome/next-steps.html?statcb=0&installdataindex=empty&defaultbrowser=0#
sudo rpm -i google-chrome-stable_current_x86_64.rpm
sudo dnf install -y alien steam wireshark gns3-gui gns3-server
sudo dnf install -y @virtualization
sudo dnf install -y gnome-tweaks gnome-extensions-app
sudo usermod -aG wireshark $USER
sudo usermod -aG kvm $USER
sudo usermod -aG libvirt $USER

dnf autoremove -y
dnf clean all
echo "Please reboot yout system now, motherfucker :)"
