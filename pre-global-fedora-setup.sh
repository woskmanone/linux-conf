#!/bin/bash

# ==========================================
# CONFIGURATION (EDIT THIS SECTION)
# ==========================================

# Set to "true" for your physical laptop/PC (Installs KVM, Libvirt, Wine, etc.)
# Set to "false" for a simple Test VM (saves space/time)
IS_WORKSTATION=true

# Set to "true" if you have an NVIDIA card and need proprietary drivers
# Set to "false" for Intel/AMD graphics
INSTALL_NVIDIA=false

# Set to "true" to install Zsh + Oh-My-Zsh (Optional preference)
INSTALL_ZSH=true

# ==========================================
# END CONFIGURATION
# ==========================================

# Check root
if [ "$EUID" -ne 0 ]; then echo "Please run as root"; exit; fi

echo "--- [1] Optimizing DNF ---"
echo 'max_parallel_downloads=10' >> /etc/dnf/dnf.conf
echo 'defaultyes=True' >> /etc/dnf/dnf.conf

echo "--- [2] Updating System ---"
dnf upgrade --refresh -y

echo "--- [3] Adding Repositories (RPM Fusion) ---"
dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
            https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y

echo "--- [4] Installing Base Tools (Git, Htop, Fastfetch, Curl) ---"
dnf install git vim htop fastfetch curl wget btop -y

echo "--- [5] Installing Multimedia Codecs ---"
dnf groupupdate core -y
dnf groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin -y
dnf groupupdate sound-and-video -y
# Intel Hardware Acceleration (safe to install even if not used)
dnf install intel-media-driver libva-intel-driver -y

# === WORKSTATION SPECIFIC ===
if [ "$IS_WORKSTATION" = true ]; then
    echo "--- [Workstation] Installing Virtualization (KVM/Libvirt) ---"
    dnf group install --with-optional virtualization -y
    systemctl enable --now libvirtd
    # Add sudo user to libvirt group
    usermod -aG libvirt $SUDO_USER
    
    echo "--- [Workstation] Installing Lab Tools (Wine, Distrobox) ---"
    dnf install wine distrobox -y
    
    echo "--- [Workstation] Enabling Flathub ---"
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi

# === NVIDIA SPECIFIC ===
if [ "$INSTALL_NVIDIA" = true ]; then
    echo "--- [GPU] Installing NVIDIA Drivers ---"
    dnf install akmod-nvidia xorg-x11-drv-nvidia-cuda -y
fi

# === ZSH SPECIFIC ===
if [ "$INSTALL_ZSH" = true ]; then
    echo "--- [Shell] Installing Zsh ---"
    dnf install zsh -y
    # Note: Oh-My-Zsh usually requires user interaction, installed later by user
fi

echo "--- [6] Cleanup ---"
dnf autoremove -y
dnf clean all

echo "=========================================="
echo " SETUP COMPLETE"
echo " Reboot is recommended."
if [ "$IS_WORKSTATION" = true ]; then
    echo " * Libvirt group updated. Relogin required."
    echo " * Packet Tracer: Use 'distrobox create ...'"
    echo " * Winbox: Run with Wine."
fi
echo "=========================================="
