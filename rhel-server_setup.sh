#!/bin/bash

# ==========================================
# ROCKY LINUX 9 HYPERVISOR SETUP
# Target: Pure KVM/QEMU + Cockpit + Bridge Prep
# ==========================================

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Check Root
if [ "$EUID" -ne 0 ]; then echo -e "${RED}Please run as root${NC}"; exit; fi

echo -e "${GREEN}Starting Rocky Linux Hypervisor Setup...${NC}"

# --- 1. System Update ---
echo -e "${YELLOW}[1/6] Updating System...${NC}"
dnf update -y

# --- 2. Install Virtualization Group ---
echo -e "${YELLOW}[2/6] Installing KVM, QEMU, Libvirt...${NC}"
# "Virtualization Host" group includes minimal packages for a host
dnf groupinstall "Virtualization Host" -y
dnf install virt-install libguestfs-tools -y

# --- 3. Install & Enable Cockpit (Web UI) ---
echo -e "${YELLOW}[3/6] Installing Cockpit & Plugins...${NC}"
dnf install cockpit cockpit-machines -y
systemctl enable --now cockpit.socket

# --- 4. Services & Firewall ---
echo -e "${YELLOW}[4/6] Configuring Services & Firewall...${NC}"
systemctl enable --now libvirtd
# Open Cockpit port (9090)
firewall-cmd --permanent --add-service=cockpit
# Allow VM traffic forwarding
firewall-cmd --permanent --zone=public --add-masquerade
firewall-cmd --reload

# --- 5. Performance Tuning (RHCSA Best Practice) ---
echo -e "${YELLOW}[5/6] Applying 'virtual-host' Tuned Profile...${NC}"
dnf install tuned -y
systemctl enable --now tuned
tuned-adm profile virtual-host
echo -e "${GREEN}System tuned for virtualization performance.${NC}"

# --- 6. Network Bridge Helper (The Smart Part) ---
echo -e "${YELLOW}[6/6] Generating Network Bridge Instructions...${NC}"

# Detect active interface (ignoring lo and virbr)
ACTIVE_IF=$(ip route get 1.1.1.1 | awk '{print $5; exit}')
CURRENT_CON=$(nmcli -t -f NAME,DEVICE connection show --active | grep ":${ACTIVE_IF}" | cut -d: -f1)

echo -e "---------------------------------------------------------"
echo -e "${GREEN}SETUP COMPLETE!${NC}"
echo -e "Web Interface: https://$(hostname -I | awk '{print $1}'):9090"
echo -e "---------------------------------------------------------"
echo -e "${YELLOW}CRITICAL NEXT STEP: NETWORK BRIDGE${NC}"
echo -e "You need a bridge (br0) so your VMs can talk to your router."
echo -e "Your active interface is: ${GREEN}${ACTIVE_IF}${NC}"
echo -e "Your current connection name is: ${GREEN}${CURRENT_CON}${NC}"
echo -e ""
echo -e "Run these commands MANUALLY to create the bridge (copy-paste):"
echo -e "---------------------------------------------------------"
echo -e "${NC}nmcli con add type bridge con-name br0 ifname br0 ipv4.method auto ipv6.method disabled"
echo -e "nmcli con add type bridge-slave ifname ${ACTIVE_IF} master br0"
echo -e "nmcli con down \"${CURRENT_CON}\" && nmcli con up br0${NC}"
echo -e "---------------------------------------------------------"
echo -e "${RED}WARNING:${NC} Running the last line might disconnect SSH for a few seconds."
echo -e "If you are local, it's instant. If remote, wait for reconnection."
