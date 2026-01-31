#!/bin/bash



# 2. Оптимізація DNF
echo "Optimizing DNF..."
echo -e "max_parallel_downloads=10\ndefaultyes=True" | sudo tee -a /etc/dnf/dnf.conf

# 3. Оновлення системи
echo "Updating system..."
sudo dnf upgrade -y

# 4. Встановлення групи віртуалізації та веб-панелі Cockpit
echo "Installing Virtualization stack and Cockpit..."
sudo dnf groupinstall -y "Virtualization Host"
sudo dnf install -y cockpit cockpit-machines cockpit-networkmanager cockpit-storaged

# 5. Активація сервісів
echo "Enabling services..."
sudo systemctl enable --now libvirtd
sudo systemctl enable --now cockpit.socket

# 6. Налаштування Firewall
echo "Configuring firewall..."
sudo firewall-cmd --permanent --add-service=cockpit
sudo firewall-cmd --permanent --add-service=libvirt
sudo firewall-cmd --reload

# 7. Встановлення корисних утиліт для адміна
echo "Installing admin tools..."
sudo dnf install -y git htop vim bash-completion screen net-tools tmux

# 8. Налаштування середовища (зручність для тебе)
echo "Adding aliases for Max..."
echo "alias vms='virsh list --all'" >> ~/.bashrc
echo "alias net-check='ip -c a && nmcli con show'" >> ~/.bashrc

echo "------------------------------------------------------"
echo "RHEL 10 SERVER SETUP COMPLETE!"
echo "Access Cockpit at: https://$(hostname -I | awk '{print $1}'):9090"
echo "------------------------------------------------------"
