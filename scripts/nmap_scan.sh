#!/bin/bash
CYAN='\033[0;36m'; YELLOW='\033[1;33m'
GREEN='\033[0;32m'; BOLD='\033[1m'; NC='\033[0m'

TARGET="${1:-scanme.nmap.org}"
OUT="./nmap-results/$(echo $TARGET | tr '.' '_')_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$OUT"

echo -e "${CYAN}${BOLD}[NMAP SCAN] Target: $TARGET${NC}\n"

echo -e "${YELLOW}[SCAN 1] Host Discovery (-sn ping sweep)${NC}"
nmap -sn "$TARGET" -oN "$OUT/1_host_discovery.txt" -v

echo -e "${YELLOW}[SCAN 2] SYN Stealth Scan - Top 1000 TCP Ports${NC}"
sudo nmap -sS -T4 "$TARGET" -oN "$OUT/2_syn_scan.txt" -v

echo -e "${YELLOW}[SCAN 3] Full Port Scan - All 65535 Ports${NC}"
sudo nmap -sS -p- -T4 "$TARGET" -oN "$OUT/3_full_ports.txt" -v

echo -e "${YELLOW}[SCAN 4] Service Version Detection${NC}"
sudo nmap -sV --version-intensity 5 "$TARGET" -oN "$OUT/4_service_version.txt" -v

echo -e "${YELLOW}[SCAN 5] OS Fingerprinting${NC}"
sudo nmap -O --osscan-guess "$TARGET" -oN "$OUT/5_os_detection.txt" -v

echo -e "${YELLOW}[SCAN 6] Default NSE Scripts${NC}"
nmap -sC -sV "$TARGET" -oN "$OUT/6_nse_scripts.txt" -v

echo -e "${YELLOW}[SCAN 7] Aggressive Scan${NC}"
sudo nmap -A "$TARGET" -oN "$OUT/7_aggressive.txt" -oX "$OUT/7_aggressive.xml" -v

echo -e "${GREEN}${BOLD}All scans done! Results in: $OUT/${NC}"
