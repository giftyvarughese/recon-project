#!/bin/bash
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; NC='\033[0m'

TARGET="$1"
if [ -z "$TARGET" ]; then
  echo -e "${RED}Usage: sudo bash recon_auto.sh <target-IP-or-domain>${NC}"
  exit 1
fi

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
OUT="./reports/scan_${TARGET}_${TIMESTAMP}"
mkdir -p "$OUT"

echo -e "${CYAN}${BOLD}Starting full recon on: $TARGET${NC}"
echo -e "Results will be saved in: $OUT\n"

echo -e "${YELLOW}[PHASE 1] Host Discovery${NC}"
nmap -sn "$TARGET" -oN "$OUT/1_host_discovery.txt"

echo -e "${YELLOW}[PHASE 2] Port Scan (Top 1000)${NC}"
sudo nmap -sS -T4 "$TARGET" -oN "$OUT/2_port_scan.txt"

echo -e "${YELLOW}[PHASE 3] Full Port Scan (all 65535)${NC}"
sudo nmap -sS -p- -T4 "$TARGET" -oN "$OUT/3_full_ports.txt"

echo -e "${YELLOW}[PHASE 4] Service Version + OS Detection${NC}"
sudo nmap -sV -O -sC "$TARGET" -oN "$OUT/4_services.txt"

echo -e "${YELLOW}[PHASE 5] OSINT - WHOIS${NC}"
whois "$TARGET" > "$OUT/5_whois.txt" 2>/dev/null

echo -e "${YELLOW}[PHASE 6] OSINT - DNS Records${NC}"
for r in A MX NS TXT; do
  echo "=== $r ===" >> "$OUT/6_dns.txt"
  dig +short "$TARGET" "$r" >> "$OUT/6_dns.txt" 2>/dev/null
done

echo -e "${YELLOW}[PHASE 7] HTTP Headers${NC}"
curl -sI --max-time 10 "https://$TARGET" > "$OUT/7_http_headers.txt" 2>/dev/null

echo -e "\n${GREEN}${BOLD}============================================"
echo " RECON COMPLETE!"
echo " All results saved in: $OUT"
echo "============================================${NC}"
ls -lh "$OUT/"
