#!/bin/bash

# 1. Прискорюємо DNF
echo "Optimizing DNF..."
echo -e "max_parallel_downloads=10\ndefaultyes=True" | sudo tee -a /etc/dnf/dnf.conf

# 2. Оновлення системи
echo "Updating system..."
sudo dnf upgrade --refresh -y

# 3. Підключення RPM Fusion (Free & Non-Free)
echo "Installing RPM Fusion..."
sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
                    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# 4. Встановлення мультимедіа кодеків (для твоєї музики 24/7)
echo "Installing multimedia codecs..."
sudo dnf groupupdate -y core
sudo dnf groupupdate -y multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
sudo dnf groupupdate -y sound-and-video

# 5. Встановлення системного та мережевого софту (Net/DevOps)
echo "Installing IT tools..."
sudo dnf install -y \
    git btop screenfetch fastfetch mc curl wget \
    wireshark \
    nmap iperf3 mtr nethogs \
    ansible podman wine \
    virt-manager qemu-kvm libvirt

# 6. Налаштування віртуалізації
echo "Configuring virtualization..."
sudo systemctl enable --now libvirtd
sudo usermod -aG libvirt $(whoami)

# 7. Підключення Flatpak (Flathub)
echo "Adding Flathub..."
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# 8. Встановлення прикладного софту через Flatpak
echo "Installing Flatpaks (Steam, Discord, Spotify, Telegram)..."
flatpak install -y flathub \
    com.valvesoftware.Steam \
    com.discordapp.Discord \
    org.telegram.desktop \

echo "------------------------------------------------------"
echo "SETUP COMPLETE!"
echo "1. Reboot your system."
echo "2. To install Packet Tracer: 'distrobox enter cisco-lab', then run 'sudo apt install ./PacketTracer.deb' inside."
echo "3. Remember to fix Wireshark permissions: 'sudo usermod -aG wireshark $(whoami)'"
echo "------------------------------------------------------"
