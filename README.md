# 🛡️ UniqueGuard Firewall for VPS & VDS

![License](https://img.shields.io/badge/License-MIT-blue.svg)
![Platform](https://img.shields.io/badge/Platform-Linux%20VPS%2FVDS-orange.svg)
![Pterodactyl](https://img.shields.io/badge/Pterodactyl-100%25%20Compatible-brightgreen.svg)
![Author](https://img.shields.io/badge/Author-mr--unique-purple.svg)
![Anti-DDoS](https://img.shields.io/badge/Anti--DDoS-Engineered-red.svg)

**UniqueGuard** is an open-source, high-performance, lightweight firewall and Anti-DDoS protection system built specifically for Virtual Private Servers (VPS) and Virtual Dedicated Servers (VDS).

Designed from the ground up to be **100% compatible with Pterodactyl Game Panel**, Docker container networking, and Linux VPS environments, UniqueGuard protects your server from network attacks without blocking Pterodactyl SFTP, Wings API, Docker bridges, or game allocations.

> **Copyright (c) 2026 [mr-unique](https://github.com/mr-unique)** — Released under the MIT Open Source License.

---

```
  _   _       _                      ____                    _
 | | | |_ __ (_) __ _ _   _  ___    / ___|_   _  __ _ _ __ _| |
 | | | | '_ \| |/ _` | | | |/ _ \  | |  _| | | |/ _` | '__/ _` |
 | |_| | | | | | (_| | |_| |  __/  | |_| | |_| | (_| | |  | (_| |
  \___/|_| |_|_|\__, |\__,_|\___|   \____|\__,_|\__,_|_|   \__,_|
                |___/
        Advanced VPS/VDS Firewall & Anti-DDoS Protection Engine
```

---

## 🔥 Key Features

- 🚀 **1-Click Installation**: Full setup in under 30 seconds with automatic dependency installation.
- 🦖 **100% Pterodactyl Panel & Wings Compatibility**:
  - Automatically preserves Docker bridges (`docker0`, `pterodactyl0`) and `DOCKER-USER` iptables chains.
  - Never interrupts internal container routing or game server port forwarding.
  - Whitelists Pterodactyl Web Panel (80/443), Wings API (8080), and Wings SFTP (2022).
  - Auto-detects active container game allocations (Minecraft, CS:GO, Rust, FiveM, SA-MP, Palworld, etc.).
- 🛡️ **Built-in Anti-DDoS & Hardening Engine**:
  - **SYN Flood Protection**: Limits TCP SYN bursts to prevent connection exhaustion.
  - **UDP Flood Mitigation**: Throttles high-frequency UDP attacks while allowing legitimate game traffic.
  - **Ping / ICMP Flood Defense**: Prevents ICMP bandwidth choking.
  - **Stealth Port Scan Defense**: Drops NULL, XMAS, FIN, and malformed TCP scan packets.
  - **Invalid Packet Filtering**: Automatically drops corrupted or out-of-state packets.
  - **Connection Rate Limiting**: Restricts maximum concurrent connections per IP.
- ⚡ **Interactive CLI (`uniqueguard`)**: Easy command line management for status, port rules, and IP blocking.
- 🔒 **Fail2ban Integration**: Included custom filters for SSH brute-force defense and Pterodactyl Panel login protection.
- 🔄 **Systemd Integration**: Runs automatically on system boot.

---

## 💻 Supported Operating Systems

- **Ubuntu** 20.04 LTS / 22.04 LTS / 24.04 LTS
- **Debian** 10 / 11 / 12
- **CentOS** 7 / 8 / 9
- **AlmaLinux** 8 / 9
- **Rocky Linux** 8 / 9

---

## 📥 Quick 1-Click Installation

Run the following command as `root` on your VPS or VDS:

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

If you prefer installing from the source repository:

```bash
# 1. Clone the repository
git clone https://github.com/mr-unique/UniqueGuard.git /tmp/UniqueGuard

# 2. Change directory
cd /tmp/UniqueGuard

# 3. Make installer executable and run
chmod +x install.sh
sudo bash install.sh
```

---

## 🦖 Pterodactyl Panel & Wings Setup Guide

UniqueGuard includes a built-in interactive wizard specifically crafted for Pterodactyl nodes.

To automatically configure UniqueGuard for your Pterodactyl installation:

```bash
sudo uniqueguard setup-pterodactyl
```

### What `setup-pterodactyl` does automatically:
1. **Whitelists Docker Interfaces**: Preserves network routing for `docker0` and `pterodactyl0`.
2. **Hooks into `DOCKER-USER`**: Prevents iptables from breaking Docker container port mapping.
3. **Opens Web & Node Ports**:
   - `80/tcp` & `443/tcp`: Pterodactyl Web Panel & SSL
   - `8080/tcp`: Pterodactyl Wings Daemon API
   - `2022/tcp`: Pterodactyl Wings SFTP File Transfer
4. **Auto-Detects Game Allocations**: Inspects running Docker game containers and opens allocated ports (TCP/UDP) automatically.
5. **Configures Game Port Ranges**: Lets you set dynamic port ranges (e.g. `25565:25600`, `27015:27050`).

---

## 🎮 Command Line Interface (CLI) Usage

The `uniqueguard` CLI tool allows you to manage rules effortlessly.

### 1. View Firewall Status
```bash
sudo uniqueguard status
```

### 2. Allow a Custom Port (TCP or UDP)
```bash
# Allow Minecraft Server Port (UDP/TCP)
sudo uniqueguard allow 25565/tcp
sudo uniqueguard allow 25565/udp

# Allow Web Server Port
sudo uniqueguard allow 8080/tcp
```

### 3. Remove an Allowed Port Rule
```bash
sudo uniqueguard deny 8080/tcp
```

### 4. Block an Attacking IP Address
```bash
sudo uniqueguard block 192.168.1.100
```

### 5. Unblock an IP Address
```bash
sudo uniqueguard unblock 192.168.1.100
```

### 6. View Dropped Attack Logs
```bash
sudo uniqueguard logs
```

### 7. Restart / Reload Firewall
```bash
sudo uniqueguard reload
```

### 8. Stop / Disable Firewall
```bash
sudo uniqueguard stop
```

---

## ⚙️ Configuration Reference (`uniqueguard.conf`)

The main configuration file is located at `/etc/uniqueguard/uniqueguard.conf`. You can edit it using `nano` or `vim`:

```bash
sudo nano /etc/uniqueguard/uniqueguard.conf
```

### Key Configuration Options:

| Setting | Default Value | Description |
| :--- | :--- | :--- |
| `ENABLE_FIREWALL` | `"true"` | Enable or disable the UniqueGuard firewall engine |
| `PTERODACTYL_MODE` | `"true"` | Enables Pterodactyl & Docker bridge protection logic |
| `PTERODACTYL_WEB_PORTS` | `"80,443"` | Pterodactyl Web Panel HTTP/HTTPS ports |
| `PTERODACTYL_WINGS_PORTS` | `"8080,2022"` | Wings Daemon API and SFTP ports |
| `TCP_IN` | `"22,80,443,8080,2022"` | Standard allowed TCP ports |
| `UDP_PORT_RANGES` | `"25565:25600 27015:27050"` | Space-separated UDP game port ranges |
| `ENABLE_ANTI_DDOS` | `"true"` | Enable Anti-DDoS flood mitigation |
| `SYN_FLOOD_LIMIT` | `"25/s"` | Maximum allowed SYN connection requests per second |
| `UDP_FLOOD_LIMIT` | `"60/s"` | Maximum allowed incoming UDP packet limit per second |
| `MAX_CONN_PER_IP` | `"30"` | Max simultaneous TCP connections permitted per single IP |
| `WHITELIST_IPS` | `"127.0.0.1 ::1"` | Space-separated list of whitelisted IPs |
| `BLACKLIST_IPS` | `""` | Space-separated list of permanently blocked IPs |

After modifying `/etc/uniqueguard/uniqueguard.conf`, reload the rules with:
```bash
sudo uniqueguard reload
```

---

## ⚙️ Systemd Service Commands

UniqueGuard runs as a native systemd service (`uniqueguard.service`).

```bash
# Check service status
sudo systemctl status uniqueguard

# Enable auto-start on boot
sudo systemctl enable uniqueguard

# Restart service
sudo systemctl restart uniqueguard
```

---

## 🗑️ Uninstallation

If you wish to cleanly uninstall UniqueGuard and restore your original iptables rules:

```bash
sudo bash uninstall.sh
```

---

## 👤 Author & Copyright

**UniqueGuard** is designed, developed, and maintained by **[mr-unique](https://github.com/mr-unique)**.

- **Author**: mr-unique
- **License**: MIT Open Source License
- **Copyright**: Copyright (c) 2026 mr-unique. All rights reserved.

---

## 📜 License

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
