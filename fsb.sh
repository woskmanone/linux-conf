#!/bin/bash
sudo wget https://pkgs.tailscale.com/stable/fedora/tailscale.repo -P /etc/yum.repos.d/
sudo rpm-ostree install tailscale --apply-live
sudo systemctl enable --now tailscaled
sudo tailscale up


# На відміну від Workstation, у Silverblue не рекомендується запускати весь скрипт від root.
# Команди самі запитають привілеї, де потрібно.

echo "--- [Repo] Налаштування репозиторіїв ---"
# RPM Fusion для Silverblue
sudo rpm-ostree install \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Включаємо Flathub (основне джерело софту)
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

echo "--- [Layers] Встановлення системних пакетів (Layering) ---"
# Тільки те, що реально має бути в системі (драйвери, віртуалізація, оболонки)
sudo rpm-ostree install \
    zsh \
    intel-media-driver libva-intel-driver \
    liberation-fonts fuse fuse-libs wget curl \
    gnome-tweaks gnome-extensions-app \
    virt-manager libvirt-daemon-config-network libvirt-daemon-kvm qemu-kvm \
    wireshark

echo "--- [Flatpak] Встановлення прикладного софту ---"
# Steam та GNS3 краще ставити як Flatpak (якщо вони є) або в Toolbx
flatpak install flathub com.valvesoftware.Steam -y

echo "--- [Post-Install] Налаштування груп та прав ---"
# Додаємо користувача до груп (виконується один раз)
sudo usermod -aG wireshark $USER
sudo usermod -aG libvirt $USER
sudo usermod -aG kvm $USER

echo "--- [Cleanup] Спроба застосувати зміни без перезавантаження ---"
# Silverblue зазвичай потребує ребуту, але --apply-live спробує змінити систему "на льоту"
sudo rpm-ostree apply-live

echo "Готово! Система Silverblue оновлена. Перезавантажтеся для завершення всіх змін."
echo "Всі додатки для розробки (Alien, GNS3-server) рекомендую ставити всередині 'toolbox enter'."
