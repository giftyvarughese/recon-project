# Reconnaissance Report
## Cybersecurity Internship Project

Student Name: Gifty Thangam Varughese
Target: scanme.nmap.org
IP Address: 45.33.32.156
Date: 20 June 2026
Tools Used: Nmap 7.99, Whois, Dig, Curl, Bash

## 1. Host Discovery
Command: nmap -sn scanme.nmap.org
Flag: -sn = ping sweep, checks if host is alive
Result: Host is up (0.0025s latency), IP: 45.33.32.156

## 2. Port Scan
Command: sudo nmap -sS -T4 scanme.nmap.org
Flags: -sS = SYN stealth scan, -T4 = fast timing
Open Ports Found:
- 22/tcp  ssh
- 80/tcp  http
- 9929/tcp nping-echo
- 31337/tcp Elite
Filtered: 25, 1141, 2179, 32777 (blocked by firewall)

## 3. Service Version Detection
Command: sudo nmap -sV -sC -T4 scanme.nmap.org
Flags: -sV = detect versions, -sC = run default scripts
Results:
- 22/tcp  SSH      OpenSSH 6.6.1p1 Ubuntu (old version - 2014)
- 80/tcp  HTTP     Apache httpd 2.4.7 Ubuntu (old version - 2013)
- 9929   nping-echo Nmap test service
- 31337  tcpwrapped restricted access
Web page title: Go ahead and ScanMe!

## 4. OS Detection
Command: sudo nmap -O --osscan-guess -T4 scanme.nmap.org
Flags: -O = OS detection, --osscan-guess = show best guess
Result: Oracle Virtualbox lwIP NAT bridge (87% confidence)
Note: Target runs inside a virtual machine

## 5. OSINT Footprinting
Sources used: whois, dig, ipinfo.io, crt.sh (all public only)

DNS Records:
- A record:    45.33.32.156
- AAAA record: 2600:3c01::f03c:91ff:fe18:bb2f

IP Geolocation (ipinfo.io):
- City: Fremont, California, USA
- Organization: AS63949 Akamai Connected Cloud
- Timezone: America/Los_Angeles

HTTP Headers:
- Server: Apache/2.4.7 (Ubuntu)

## 6. Key Findings

| Finding              | Risk   |
|----------------------|--------|
| OpenSSH 6.6.1 (2014) | Medium |
| Apache 2.4.7 (2013)  | Medium |
| Server version exposed in headers | Low |
| Firewall blocking multiple ports  | Info  |
| Running inside VirtualBox VM      | Info  |

## 7. Recommendations
- Upgrade OpenSSH to version 9.x
- Upgrade Apache to 2.4.62 or latest
- Hide server version: set ServerTokens Prod in Apache config
- Investigate port 31337 and close if not needed

## 8. Conclusion
Successfully performed automated reconnaissance using Bash scripts
and Nmap on an authorized lab target. All open ports identified,
service versions detected, OS fingerprinted, and OSINT collected
from public sources only.

Report prepared as part of Cybersecurity Internship Project - June 2026
