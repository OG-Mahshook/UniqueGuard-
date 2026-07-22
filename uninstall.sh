#!/usr/bin/env bash
# =====================================================================
# UniqueGuard - Clean Uninstaller Script
# Author & Copyright: mr-unique
# =====================================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'
BOLD='\033[1m'

if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}[ERROR] Uninstallation requires root privileges.${NC}"
    exit 1
fi

echo -e "${CYAN}${BOLD}[*] Starting UniqueGuard Uninstallation...${NC}"

# Stop firewall rules
if [ -f "/usr/local/bin/uniqueguard" ]; then
    /usr/local/bin/uniqueguard stop || true
fi

# Disable & remove systemd service
if systemctl is-enabled uniqueguard.service &>/dev/null; then
    systemctl disable uniqueguard.service &>/dev/null || true
fi
rm -f /etc/systemd/system/uniqueguard.service
systemctl daemon-reload

# Remove binary
rm -f /usr/local/bin/uniqueguard

# Remove fail2ban config
rm -f /etc/fail2ban/jail.d/pterodactyl.conf

# Prompt for config directory removal
read -rp "Do you want to delete configuration files in /etc/uniqueguard? (y/N): " remove_cfg
if [[ "$remove_cfg" =~ ^[Yy]$ ]]; then
    rm -rf /etc/uniqueguard
    echo -e "${YELLOW}  [+] Configuration directory removed.${NC}"
else
    echo -e "${GREEN}  [!] Configuration files preserved at /etc/uniqueguard${NC}"
fi

echo -e "\n${GREEN}${BOLD}[SUCCESS] UniqueGuard has been completely uninstalled.${NC}\n"
