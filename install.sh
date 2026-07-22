#!/usr/bin/env bash
# =====================================================================
# UNIQUE GUARD - Automated One-Click Installer
# Author & Copyright: mr-unique
# License: MIT
# Website/Repo: https://github.com/OG-Mahshook/UniqueGuard-
# =====================================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'
BOLD='\033[1m'

print_header() {
    echo -e "${CYAN}${BOLD}"
    echo '  _   _ _   _ ___ _____  _   _ _____    ____ _   _    _    ____  ____  '
    echo ' | | | | \ | |_ _|  _  || | | | ____|  / ___| | | |  / \  |  _ \|  _ \ '
    echo ' | | | |  \| || || | | || | | |  _|   | |  _| | | | / _ \ | |_) | | | |'
    echo ' | |_| | |\  || || |_| || |_| | |___  | |_| | |_| |/ ___ \|  _ <| |_| |'
    echo '  \___/|_| \_|___|\____\_\___/|_____|  \____|\___//_/   \_\_| \_\____/ '
    echo -e "         ${YELLOW}One-Click Installation Wizard for VPS & VDS${NC}"
    echo -e "            ${GREEN}Copyright (c) 2026 mr-unique${NC}\n"
}

print_header

# 1. Check Root User
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}[ERROR] Installation requires root privileges.${NC}"
    echo -e "Please run with ${YELLOW}sudo bash install.sh${NC} or as root."
    exit 1
fi

# 2. OS & Package Manager Detection
echo -e "${BLUE}[1/5] Detecting Linux Distribution and Package Manager...${NC}"
if command -v apt-get &>/dev/null; then
    PKG_MANAGER="apt"
elif command -v dnf &>/dev/null; then
    PKG_MANAGER="dnf"
elif command -v yum &>/dev/null; then
    PKG_MANAGER="yum"
elif command -v pacman &>/dev/null; then
    PKG_MANAGER="pacman"
else
    echo -e "${YELLOW}[WARNING] Unknown package manager. Dependencies must be installed manually.${NC}"
fi

# 3. Install Dependencies
echo -e "${BLUE}[2/5] Installing core dependencies (iptables, ipset, fail2ban, curl)...${NC}"
if [ "$PKG_MANAGER" = "apt" ]; then
    export DEBIAN_FRONTEND=noninteractive
    apt-get update -qq
    apt-get install -y -qq iptables iptables-persistent ipset fail2ban curl &>/dev/null || true
elif [ "$PKG_MANAGER" = "dnf" ] || [ "$PKG_MANAGER" = "yum" ]; then
    $PKG_MANAGER install -y iptables iptables-services ipset fail2ban curl &>/dev/null || true
elif [ "$PKG_MANAGER" = "pacman" ]; then
    pacman -Sy --noconfirm iptables ipset fail2ban curl &>/dev/null || true
fi
echo -e "${GREEN}  [✓] Dependencies installed successfully.${NC}"

# 4. Copy Executable, Configuration & Systemd Files
echo -e "${BLUE}[3/5] Installing UNIQUE GUARD binaries & configurations...${NC}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p /etc/uniqueguard

if [ ! -f "/etc/uniqueguard/uniqueguard.conf" ]; then
    cp "${SCRIPT_DIR}/config/uniqueguard.conf" /etc/uniqueguard/uniqueguard.conf
    echo -e "  [+] Created default config at ${GREEN}/etc/uniqueguard/uniqueguard.conf${NC}"
else
    echo -e "  [!] Existing config file detected. Preserved ${YELLOW}/etc/uniqueguard/uniqueguard.conf${NC}"
fi

cp "${SCRIPT_DIR}/bin/uniqueguard" /usr/local/bin/uniqueguard
chmod +x /usr/local/bin/uniqueguard
echo -e "  [+] Installed CLI executable to ${GREEN}/usr/local/bin/uniqueguard${NC}"

# Install Fail2ban config if present
if [ -d "/etc/fail2ban/jail.d" ] && [ -f "${SCRIPT_DIR}/config/fail2ban-pterodactyl.conf" ]; then
    cp "${SCRIPT_DIR}/config/fail2ban-pterodactyl.conf" /etc/fail2ban/jail.d/pterodactyl.conf 2>/dev/null || true
    systemctl restart fail2ban 2>/dev/null || true
    echo -e "  [+] Configured fail2ban jails for Pterodactyl and SSH"
fi

# 5. Configure Systemd Service
echo -e "${BLUE}[4/5] Registering systemd service...${NC}"
cp "${SCRIPT_DIR}/systemd/uniqueguard.service" /etc/systemd/system/uniqueguard.service
systemctl daemon-reload
systemctl enable uniqueguard.service &>/dev/null
echo -e "  [+] UNIQUE GUARD systemd service enabled for boot startup."

# 6. Initial Activation
echo -e "${BLUE}[5/5] Activating UNIQUE GUARD Firewall...${NC}"
/usr/local/bin/uniqueguard start

echo -e "\n${GREEN}${BOLD}========================================================================${NC}"
echo -e "${GREEN}${BOLD}     UNIQUE GUARD Firewall Installed Successfully! (by mr-unique)      ${NC}"
echo -e "${GREEN}${BOLD}========================================================================${NC}\n"
echo -e "Quick Management Commands:"
echo -e "  ${YELLOW}uniqueguard status${NC}           - View firewall status and active rules"
echo -e "  ${YELLOW}uniqueguard profile minecraft${NC}- Apply pre-configured server profile"
echo -e "  ${YELLOW}uniqueguard setup-pterodactyl${NC}- Run auto-configuration wizard for Pterodactyl"
echo -e "  ${YELLOW}uniqueguard monitor${NC}          - Launch real-time network & attack dashboard"
echo -e "  ${YELLOW}uniqueguard audit${NC}            - Run security posture audit report"
echo -e "  ${YELLOW}uniqueguard allow 25565/udp${NC}  - Allow custom game/app port"
echo -e "  ${YELLOW}uniqueguard block 1.2.3.4${NC}    - Block an attacking IP"
echo -e "  ${YELLOW}uniqueguard help${NC}             - Show all available commands\n"
