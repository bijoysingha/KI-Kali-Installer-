#!/bin/bash
# Ki Kali Installer v2.0
# By: You :)

set -e

BASE_URL="https://kali.download/nethunter-images/current/rootfs"

# ===== Colors =====
RED='\033[0;31m'
WHITE='\033[1;37m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ===== Banner =====
banner() {
  clear
  echo -e "${RED}#########################################${NC}"
  echo -e "${RED}##${NC} ${WHITE}|||${NC}    ${BLUE}///${NC}       ${WHITE}|||||||||||||||||${NC} ${RED}##${NC}"
  echo -e "${RED}##${NC} ${WHITE}|||${NC}   ${BLUE}///${NC}            ${WHITE}||${NC}             ${RED}##${NC}"
  echo -e "${RED}##${NC} ${WHITE}|||${NC}  ${BLUE}///${NC}             ${WHITE}||${NC}             ${RED}##${NC}"
  echo -e "${RED}##${NC} ${WHITE}|||${NC} ${BLUE}///${NC}              ${WHITE}||${NC}             ${RED}##${NC}"
  echo -e "${RED}##${NC} ${WHITE}|||${NC} ${BLUE}\\\\\\${NC}             ${WHITE}||${NC}             ${RED}##${NC}"
  echo -e "${RED}##${NC} ${WHITE}|||${NC}  ${BLUE}\\\\\\${NC}            ${WHITE}||${NC}             ${RED}##${NC}"
  echo -e "${RED}##${NC} ${WHITE}|||${NC}   ${BLUE}\\\\\\${NC}           ${WHITE}||${NC}             ${RED}##${NC}"
  echo -e "${RED}##${NC} ${WHITE}|||${NC}    ${BLUE}\\\\\\${NC}     ${WHITE}|||||||||||||||||${NC} ${RED}##${NC}"
  echo -e "${RED}#########################################${NC}"
  echo -e "          ${WHITE}[ Ki Kali Installer v2.0 ]${NC}"
  echo ""
}

# ===== Menu Options =====
OPTIONS=(
  "Full - amd64 (2.5 GiB)"
  "Full - arm64 (2.1 GiB)"
  "Full - armhf (2.0 GiB)"
  "Full - i386 (2.2 GiB)"
  "Minimal - amd64 (136 MiB)"
  "Minimal - arm64 (131 MiB)"
  "Minimal - armhf (122 MiB)"
  "Minimal - i386 (138 MiB)"
  "Nano - amd64 (192 MiB)"
  "Nano - arm64 (185 MiB)"
  "Nano - armhf (174 MiB)"
  "Nano - i386 (187 MiB)"
)

FILES=(
  "kali-nethunter-rootfs-full-amd64.tar.xz"
  "kali-nethunter-rootfs-full-arm64.tar.xz"
  "kali-nethunter-rootfs-full-armhf.tar.xz"
  "kali-nethunter-rootfs-full-i386.tar.xz"
  "kali-nethunter-rootfs-minimal-amd64.tar.xz"
  "kali-nethunter-rootfs-minimal-arm64.tar.xz"
  "kali-nethunter-rootfs-minimal-armhf.tar.xz"
  "kali-nethunter-rootfs-minimal-i386.tar.xz"
  "kali-nethunter-rootfs-nano-amd64.tar.xz"
  "kali-nethunter-rootfs-nano-arm64.tar.xz"
  "kali-nethunter-rootfs-nano-armhf.tar.xz"
  "kali-nethunter-rootfs-nano-i386.tar.xz"
)

# ===== Main =====
banner

echo "Select a Kali NetHunter rootfs to install:"
echo ""

# Show menu
for i in "${!OPTIONS[@]}"; do
  printf "%2d) %s\n" $((i+1)) "${OPTIONS[$i]}"
done

echo ""
read -p "Enter choice [1-${#OPTIONS[@]}]: " CHOICE

if [[ "$CHOICE" -lt 1 || "$CHOICE" -gt ${#OPTIONS[@]} ]]; then
  echo "[!] Invalid choice."
  exit 1
fi

FILE=${FILES[$((CHOICE-1))]}
URL="$BASE_URL/$FILE"

echo "[*] You selected: ${OPTIONS[$((CHOICE-1))]}"
echo "[*] Downloading from: $URL"

# Download
wget -O kali-rootfs.tar.xz "$URL"

# Extract
echo "[*] Extracting rootfs..."
mkdir -p kali-rootfs
tar -xJf kali-rootfs.tar.xz -C kali-rootfs

# Start script
cat > start-kali.sh <<- EOM
#!/bin/bash
cd kali-rootfs
exec proot -0 -r . -b /dev -b /proc -b /sys -w /root /bin/bash
EOM

chmod +x start-kali.sh

echo ""
echo "[✔] Installation complete!"
echo "Run ./start-kali.sh to enter Kali."
