# 🛡️ UNIQUE GUARD Firewall for VPS & VDS

![License](https://img.shields.io/badge/License-MIT-blue.svg)
![Platform](https://img.shields.io/badge/Platform-Linux%20VPS%2FVDS-orange.svg)
![Pterodactyl](https://img.shields.io/badge/Pterodactyl-100%25%20Compatible-brightgreen.svg)
![Author](https://img.shields.io/badge/Author-mr--unique-purple.svg)
![Anti-DDoS](https://img.shields.io/badge/Anti--DDoS-Engineered-red.svg)
![Build](https://img.shields.io/badge/Build-v1.2.1-success.svg)

**UNIQUE GUARD** is an open-source, enterprise-grade, high-performance firewall and Anti-DDoS protection system designed specifically for Virtual Private Servers (VPS) and Virtual Dedicated Servers (VDS).

Created from the ground up to be **100% compatible with Pterodactyl Game Panel**, Docker container networking, game servers, web apps, databases, and Linux hosting environments. **UNIQUE GUARD** defends your server against aggressive network floods, port scans, and brute-force attacks without interrupting Pterodactyl SFTP, Wings API, Docker bridges, or game allocations.

> **Copyright (c) 2026 [mr-unique](https://github.com/mr-unique)** — Released under the MIT Open Source License.

---

```text
  _   _ _   _ ___ _____  _   _ _____    ____ _   _    _    ____  ____  
 | | | | \ | |_ _|  _  || | | | ____|  / ___| | | |  / \  |  _ \|  _ \ 
 | | | |  \| || || | | || | | |  _|   | |  _| | | | / _ \ | |_) | | | |
 | |_| | |\  || || |_| || |_| | |___  | |_| | |_| |/ ___ \|  _ <| |_| |
  \___/|_| \_|___|\____\_\___/|_____|  \____|\___//_/   \_\_| \_\____/ 
        Advanced VPS/VDS Firewall & Pterodactyl Anti-DDoS Engine
```

---

## 📚 Table of Contents

- [🔥 Key Features](#-key-features)
- [⭐ Key Advantages Over Other Firewalls](#-key-advantages-over-other-firewalls)
- [💻 Supported Operating Systems](#-supported-operating-systems)
- [📥 Quick 1-Click Installation](#-quick-1-click-installation)
- [🛠️ Manual Installation (Git Clone)](#️-manual-installation-git-clone)
- [🦖 Pterodactyl Panel & Wings Setup Guide](#-pterodactyl-panel--wings-setup-guide)
- [🎮 Complete Usage Guide & CLI Commands](#-complete-usage-guide--cli-commands)
  - [1. Core Management Commands](#1-core-management-commands)
  - [2. Port Management Commands](#2-port-management-commands)
  - [3. IP Blacklisting & Whitelisting](#3-ip-blacklisting--whitelisting)
  - [4. Service Profiles (`minecraft`, `rust`, `fivem`, `csgo`, `web`, `database`)](#4-service-profiles-minecraft-rust-fivem-csgo-web-database)
  - [5. Live Attack & Connection Monitor](#5-live-attack--connection-monitor)
  - [6. VPS Security Audit Tool](#6-vps-security-audit-tool)
  - [7. Discord Webhook Attack Alerts](#7-discord-webhook-attack-alerts)
  - [8. Rule Backup & Restore](#8-rule-backup--restore)
- [⚙️ Configuration Reference (`uniqueguard.conf`)](#️-configuration-reference-uniqueguardconf)
- [⚙️ Systemd Service Control](#️-systemd-service-control)
- [🗑️ Uninstallation](#️-uninstallation)
- [👤 Author & Copyright](#-author--copyright)
- [📜 License](#-license)

---

## 🔥 Key Features

- 🚀 **30-Second Automated Setup**: One-click install script automatically handles OS detection and package dependencies (`iptables`, `ipset`, `fail2ban`, `curl`).
- 🦖 **100% Pterodactyl Panel & Wings Compatibility**:
  - Automatically preserves Docker bridges (`docker0`, `pterodactyl0`) and `DOCKER-USER` iptables chains.
  - Never breaks internal container routing or game server port forwarding.
  - Whitelists Pterodactyl Web Panel (80/443), Wings API (8080), and Wings SFTP (2022).
  - Auto-detects active container game allocations (Minecraft, CS:GO, Rust, FiveM, SA-MP, Palworld, ARK, etc.).
- 🛡️ **Anti-DDoS & Traffic Hardening Engine**:
  - **TCP SYN Flood Mitigation**: Restricts TCP connection rate bursts to prevent server memory exhaustion.
  - **UDP Flood Defense**: Rate-limits incoming UDP packet bursts while preserving legitimate game traffic.
  - **Ping / ICMP Flood Defense**: Throttles ping requests to prevent bandwidth saturation.
  - **Stealth Port Scan Defense**: Drops NULL scans, XMAS scans, SYN-FIN scans, and malformed TCP flags.
  - **Invalid Packet Filtering**: Automatically drops corrupted or out-of-state packets.
  - **Connection Rate Limiting**: Enforces max concurrent TCP connections per IP.
- 🎯 **Pre-built Service Profiles**: 1-click profiles for Minecraft, Rust, FiveM, SA-MP, CS:GO/CS2, Web Servers, and Databases.
- 🔔 **Discord Webhook Alerts**: Real-time Discord notifications when attacks occur or IPs get blocked.
- 📊 **Real-time Monitoring & Security Audits**: Built-in network dashboard (`uniqueguard monitor`) and vulnerability scanner (`uniqueguard audit`).
- 🔒 **Fail2ban Integration**: Includes pre-configured jails for SSH brute-force defense and Pterodactyl Panel login defense.

---

## ⭐ Key Advantages Over Other Firewalls

| Feature / Capability | Standard Firewalls (UFW / iptables) | UNIQUE GUARD |
| :--- | :---: | :---: |
| **Pterodactyl Panel & Wings Safe** | ❌ Often breaks Docker bridges (`docker0`, `pterodactyl0`) | ✅ **100% Safe (Auto-Whitelisted)** |
| **Docker `DOCKER-USER` NAT Chain** | ❌ Clears/wipes container mapping chains | ✅ **Preserved & Integrated** |
| **Anti-DDoS Packet Burst Limiters** | ❌ Only allows/denies ports (No DDoS defense) | ✅ **Built-in TCP SYN & UDP Flood Limiters** |
| **Stealth Scan & Malformed Packets** | ❌ Allows scanning probes | ✅ **Drops NULL, XMAS, FIN Stealth Scans** |
| **1-Click Game & Server Profiles** | ❌ Manual rule entry for every port | ✅ **Instant `uniqueguard profile <game>`** |
| **Discord Real-time Webhook Alerts** | ❌ None | ✅ **Real-time Attack Notifications** |
| **Live Network & Attack Dashboard** | ❌ None | ✅ **Built-in (`uniqueguard monitor`)** |
| **VPS Security Audit Scanner** | ❌ None | ✅ **Built-in (`uniqueguard audit`)** |
| **Resource Usage** | ⚠️ High (if bloated daemon) | ⚡ **0% CPU, < 5MB RAM (Kernel-level)** |

---

## 💻 Supported Operating Systems

- **Ubuntu** 20.04 LTS / 22.04 LTS / 24.04 LTS
- **Debian** 10 / 11 / 12
- **CentOS** 7 / 8 / 9
- **AlmaLinux** 8 / 9
- **Rocky Linux** 8 / 9

---

## 📥 Quick 1-Click Installation

Run the following one-line command as `root` on your VPS or VDS:

### Using `curl`:
```bash
curl -sSL https://raw.githubusercontent.com/mr-unique/UniqueGuard/main/install.sh | bash
```

### Using `wget`:
```bash
wget -qO- https://raw.githubusercontent.com/mr-unique/UniqueGuard/main/install.sh | bash
```

---

## 🛠️ Manual Installation (Git Clone)

```bash
# 1. Clone repository
git clone https://github.com/mr-unique/UniqueGuard.git /tmp/UniqueGuard

# 2. Change directory
cd /tmp/UniqueGuard

# 3. Make installer executable and run
chmod +x install.sh
sudo bash install.sh
```

---

## 🦖 Pterodactyl Panel & Wings Setup Guide

**UNIQUE GUARD** provides a built-in wizard specifically designed for Pterodactyl nodes.

To automatically configure **UNIQUE GUARD** for your Pterodactyl node:

```bash
sudo uniqueguard setup-pterodactyl
```

### How UNIQUE GUARD protects Pterodactyl:
1. **Preserves Docker Interfaces**: Keeps `docker0` and `pterodactyl0` open so containers can talk to Wings without connection timeouts.
2. **Preserves `DOCKER-USER` Chain**: Ensures Docker's internal NAT rules remain intact.
3. **Whitelists Core Ports**:
   - `80/tcp` & `443/tcp`: Web Panel & SSL
   - `8080/tcp`: Wings Daemon API
   - `2022/tcp`: Wings SFTP File Transfer
4. **Auto-Detects Container Allocations**: Scans active Docker containers and automatically opens their allocated game ports (TCP/UDP).

---

## 🎮 Complete Usage Guide & CLI Commands

### 1. Core Management Commands

| Command | Description |
| :--- | :--- |
| `sudo uniqueguard start` | Start and apply all firewall and Anti-DDoS rules |
| `sudo uniqueguard stop` | Stop firewall and restore open network policies |
| `sudo uniqueguard reload` | Reload configuration and re-apply rules |
| `sudo uniqueguard status` | Display active firewall status, statistics, and rules |
| `sudo uniqueguard logs` | View recent dropped attack connection logs |
| `sudo uniqueguard help` | Show CLI help menu |

---

### 2. Port Management Commands

#### Allow a Specific Port:
```bash
# Allow Minecraft Port (UDP & TCP)
sudo uniqueguard allow 25565/tcp
sudo uniqueguard allow 25565/udp

# Allow Custom Web App Port
sudo uniqueguard allow 8080/tcp
```

#### Deny / Remove an Allowed Port:
```bash
sudo uniqueguard deny 8080/tcp
```

---

### 3. IP Blacklisting & Whitelisting

#### Block an Attacking IP Immediately:
```bash
sudo uniqueguard block 192.168.1.100
```

#### Unblock an IP Address:
```bash
sudo uniqueguard unblock 192.168.1.100
```

---

### 4. Service Profiles (`minecraft`, `rust`, `fivem`, `csgo`, `web`, `database`)

Apply pre-configured port rules for game servers or software stacks with a single command:

```bash
# Apply Minecraft Profile (25565/tcp, 25565/udp, 25575 RCON, 8123 Dynmap)
sudo uniqueguard profile minecraft

# Apply Rust Server Profile (28015/udp, 28016 RCON, 28082 App)
sudo uniqueguard profile rust

# Apply FiveM Server Profile (30120/tcp, 30120/udp, 40120 txAdmin)
sudo uniqueguard profile fivem

# Apply SA-MP Profile (7777/udp)
sudo uniqueguard profile samp

# Apply CS:GO / CS2 Profile (27015/tcp, 27015/udp, 27020 GOTV)
sudo uniqueguard profile csgo

# Apply Web Server Profile (80/tcp HTTP, 443/tcp HTTPS)
sudo uniqueguard profile web

# Apply Database Profile (3306 MySQL, 5432 Postgres, 6379 Redis)
sudo uniqueguard profile database
```

---

### 5. Live Attack & Connection Monitor

Launch real-time packet throughput, top connecting IPs, and attack log monitor:

```bash
sudo uniqueguard monitor
```

---

### 6. VPS Security Audit Tool

Run a full security posture and hardening audit report on your VPS:

```bash
sudo uniqueguard audit
```

---

### 7. Discord Webhook Attack Alerts

Get instant notifications in your Discord channel whenever an IP is blocked or an attack is detected!

1. Edit `/etc/uniqueguard/uniqueguard.conf`:
```bash
sudo nano /etc/uniqueguard/uniqueguard.conf
```
2. Update settings:
```bash
ENABLE_DISCORD_ALERTS="true"
DISCORD_WEBHOOK_URL="https://discord.com/api/webhooks/YOUR_WEBHOOK_URL_HERE"
```
3. Reload firewall:
```bash
sudo uniqueguard reload
```

---

### 8. Rule Backup & Restore

#### Create Backup Archive:
```bash
sudo uniqueguard backup
```

#### Restore from Backup Archive:
```bash
sudo uniqueguard restore /var/backups/uniqueguard/uniqueguard_backup_20260722_120000.tar.gz
```

---

## ⚙️ Configuration Reference (`uniqueguard.conf`)

Located at `/etc/uniqueguard/uniqueguard.conf`:

```bash
# General Settings
ENABLE_FIREWALL="true"
DEFAULT_INPUT_POLICY="DROP"

# Pterodactyl Node Mode
PTERODACTYL_MODE="true"
PTERODACTYL_WEB_PORTS="80,443"
PTERODACTYL_WINGS_PORTS="8080,2022"
DOCKER_INTERFACES="docker0 pterodactyl0"
AUTO_DETECT_WINGS_ALLOCATIONS="true"

# Allowed Ports
TCP_IN="22,80,443,8080,2022"
UDP_IN=""
UDP_PORT_RANGES="25565:25600 27015:27050 7777:7800"

# Anti-DDoS Thresholds
ENABLE_ANTI_DDOS="true"
SYN_FLOOD_LIMIT="25/s"
SYN_FLOOD_BURST="50"
UDP_FLOOD_LIMIT="60/s"
UDP_FLOOD_BURST="120"
PING_LIMIT="5/s"
MAX_CONN_PER_IP="30"

# IP Lists
WHITELIST_IPS="127.0.0.1 ::1"
BLACKLIST_IPS=""

# Discord Alerts
ENABLE_DISCORD_ALERTS="false"
DISCORD_WEBHOOK_URL=""
```

---

## ⚙️ Systemd Service Control

```bash
# Check service status
sudo systemctl status uniqueguard

# Enable service on boot
sudo systemctl enable uniqueguard

# Restart service
sudo systemctl restart uniqueguard
```

---

## 🗑️ Uninstallation

To cleanly remove **UNIQUE GUARD** and restore standard open policies:

```bash
sudo bash uninstall.sh
```

---

## 👤 Author & Copyright

**UNIQUE GUARD** is designed, created, and maintained by **[mr-unique](https://github.com/mr-unique)**.

- **Author**: mr-unique
- **License**: MIT Open Source License
- **Copyright**: Copyright (c) 2026 mr-unique. All rights reserved.

---

## 📜 License

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
