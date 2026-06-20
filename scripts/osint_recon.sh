#!/bin/bash
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; NC='\033[0m'

TARGET="$1"
OUT="./osint/${TARGET}_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$OUT"

if [ -z "$TARGET" ]; then
  echo -e "${RED}Usage: bash osint_recon.sh <domain>${NC}"
  exit 1
fi

REPORT="$OUT/osint_report.md"
echo "# OSINT Report - $TARGET" > "$REPORT"
echo "Date: $(date)" >> "$REPORT"

echo -e "${YELLOW}[1/5] WHOIS Lookup...${NC}"
echo "## WHOIS" >> "$REPORT"
whois "$TARGET" 2>/dev/null | tee -a "$OUT/whois.txt" >> "$REPORT"

echo -e "${YELLOW}[2/5] DNS Records...${NC}"
echo "## DNS Records" >> "$REPORT"
for record in A MX NS TXT AAAA; do
  echo "### $record" >> "$REPORT"
  dig +short "$TARGET" "$record" 2>/dev/null | tee -a "$OUT/dns.txt" >> "$REPORT"
done

echo -e "${YELLOW}[3/5] Subdomains via crt.sh...${NC}"
echo "## Subdomains" >> "$REPORT"
curl -s "https://crt.sh/?q=%25.$TARGET&output=json" 2>/dev/null \
  | python3 -c "
import sys,json
try:
  data=json.load(sys.stdin)
  seen=set()
  for e in data:
    for s in e.get('name_value','').split('\n'):
      s=s.strip().lstrip('*.')
      if s and s not in seen:
        seen.add(s); print(s)
except: print('Could not fetch')
" | sort -u | tee -a "$OUT/subdomains.txt" >> "$REPORT"

echo -e "${YELLOW}[4/5] HTTP Headers...${NC}"
echo "## HTTP Headers" >> "$REPORT"
curl -sI --max-time 10 "https://$TARGET" 2>/dev/null | tee -a "$OUT/headers.txt" >> "$REPORT"

echo -e "${YELLOW}[5/5] IP Geolocation...${NC}"
echo "## IP Info" >> "$REPORT"
IP=$(dig +short "$TARGET" A | head -1)
curl -s "https://ipinfo.io/$IP/json" 2>/dev/null | tee -a "$OUT/ipinfo.txt" >> "$REPORT"

echo -e "${GREEN}${BOLD}OSINT Done! Report: $REPORT${NC}"
