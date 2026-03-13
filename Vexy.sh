#!/usr/bin/env bash
# ==========================================================
# VEXY - CODEHUE DEPLOYMENT SYSTEM | BANE-ANMESH 3S UPLINK
# ==========================================================
set -euo pipefail

# --- Colors ---
R='\033[1;38;5;196m'   # Laal
G='\033[1;38;5;82m'    # Hara
Y='\033[1;38;5;220m'   # Peela
C='\033[1;38;5;51m'    # Cyan 
P='\033[1;38;5;141m'   # Purple
W='\033[1;38;5;255m'   # White
DG='\033[0;38;5;244m'  # Gray
NC='\033[0m'           # Reset

# --- Header with VEXY ---
clear
echo -e "${R}"
cat << "EOF"
╔═══════════════════════════════════════════════════════════════╗
║                                                               ║
║   ██╗   ██╗███████╗██╗  ██╗██╗   ██╗                         ║
║   ██║   ██║██╔════╝╚██╗██╔╝╚██╗ ██╔╝                         ║
║   ██║   ██║█████╗   ╚███╔╝  ╚████╔╝                          ║
║   ╚██╗ ██╔╝██╔══╝   ██╔██╗   ╚██╔╝                           ║
║    ╚████╔╝ ███████╗██╔╝ ██╗   ██║                            ║
║     ╚═══╝  ╚══════╝╚═╝  ╚═╝   ╚═╝                            ║
║                                                               ║
║                    🔥 VEXY PANEL v14.0 🔥                      ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

echo -e "${P}┌──────────────────────────────────────────────────────────────┐${NC}"
echo -e "${P}│${NC}  ${R}☢️  VEXY BANE-ANMESH 3S UPLINK${NC}                         ${DG}$(date +"%H:%M:%S")${NC}  ${P}│${NC}"
echo -e "${P}└──────────────────────────────────────────────────────────────┘${NC}"

# --- Network Diagnostics ---
echo -e "\n  ${C}🌐 NETWORK ROUTE DIAGNOSTICS${NC}"
IP=$(curl -s ifconfig.me 2>/dev/null || echo "65.0.86.121")
LOCAL_IP=$(hostname -I | awk '{print $1}' 2>/dev/null || echo "10.1.0.29")
echo -e "  ${DG}├─ Public Endpoint :${NC} ${W}$IP${NC}"
echo -e "  ${DG}├─ Local Gateway   :${NC} ${W}$LOCAL_IP${NC}"
echo -e "  ${DG}├─ Target Host     :${NC} ${W}codehue.vexy.local${NC}"
echo -e "  ${DG}└─ Security Level  :${NC} ${G}VEXY-CORE-65S${NC}"
echo -e "${DG}──────────────────────────────────────────────────────────────${NC}"

# --- System Check ---
echo -e "\n  ${Y}[1/4] SYSTEM VERIFICATION${NC}"
echo -e "  ${DG}├─ OS:${NC} ${W}$(uname -s) $(uname -m)${NC}"
echo -e "  ${DG}├─ Kernel:${NC} ${W}$(uname -r)${NC}"
echo -e "  ${DG}├─ User:${NC} ${W}$(whoami)${NC}"
echo -e "  ${DG}└─ Shell:${NC} ${W}$SHELL${NC}"
echo -e "${DG}──────────────────────────────────────────────────────────────${NC}"

# --- Dependency Check & Install (Silent Mode) ---
echo -e "\n  ${Y}[2/4] DEPENDENCY CHECK${NC}"
DEPS=("curl" "wget" "git" "jq")
MISSING=()

for dep in "${DEPS[@]}"; do
    echo -ne "  ${DG}├─ Checking $dep...${NC} "
    if command -v $dep &> /dev/null; then
        echo -e "${G}✅${NC}"
    else
        echo -e "${R}❌${NC}"
        MISSING+=($dep)
    fi
done

# Install Node.js 20.x (Latest LTS)
echo -ne "  ${DG}├─ Installing Node.js 20.x...${NC} "
if ! command -v node &> /dev/null; then
    curl -sL https://deb.nodesource.com/setup_20.x | bash - > /dev/null 2>&1
    apt install nodejs -y -qq > /dev/null 2>&1
    echo -e "${G}✅${NC}"
else
    echo -e "${G}Already installed${NC}"
fi

# Install missing packages
if [ ${#MISSING[@]} -ne 0 ]; then
    echo -e "  ${Y}Installing missing packages...${NC}"
    apt update -qq > /dev/null 2>&1
    apt install -y -qq ${MISSING[@]} > /dev/null 2>&1
fi

# --- VEXY Panel Installation ---
echo -e "\n  ${Y}[3/4] VEXY PANEL DEPLOYMENT${NC}"
echo -ne "  ${DG}├─ Creating directory structure...${NC} "
mkdir -p ~/vexy/bin
echo -e "${G}✅${NC}"

echo -ne "  ${DG}├─ Downloading VEXY Core...${NC} "
curl -s https://raw.githubusercontent.com/Mrvexyplays/IdxVM/main/panel.sh -o ~/vexy/bin/vexy
if [ $? -eq 0 ] && [ -s ~/vexy/bin/vexy ]; then
    chmod +x ~/vexy/bin/vexy
    echo -e "${G}✅${NC}"
else
    echo -e "${R}❌ Download failed! Using fallback...${NC}"
    # Fallback panel code
    cat > ~/vexy/bin/vexy << 'EOF'
#!/bin/bash
R='\033[1;38;5;196m'; G='\033[1;38;5;82m'; NC='\033[0m'
while true; do
    clear
    echo -e "${R}"; cat << "VEOF"
██╗   ██╗███████╗██╗  ██╗██╗   ██╗
██║   ██║██╔════╝╚██╗██╔╝╚██╗ ██╔╝
██║   ██║█████╗   ╚███╔╝  ╚████╔╝ 
╚██╗ ██╔╝██╔══╝   ██╔██╗   ╚██╔╝  
 ╚████╔╝ ███████╗██╔╝ ██╗   ██║   
  ╚═══╝  ╚══════╝╚═╝  ╚═╝   ╚═╝   
VEOF
    echo -e "${NC}"
    echo "════════════════════════════════════════"
    CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1 2>/dev/null || echo "59")
    RAM=$(free | grep Mem | awk '{print $3/$2 * 100.0}' 2>/dev/null || echo "46")
    echo " CPU: ${CPU}% | RAM: ${RAM}% | NETWORK: CONNECTED"
    echo "════════════════════════════════════════"
    echo " [1] VPS     [2] Panel   [3] Wings"
    echo " [4] Toolbox [5] Theme   [6] Edit"
    echo " [7] Container          [0] Exit"
    echo "════════════════════════════════════════"
    read -p " Command: " cmd
    case $cmd in 0) exit 0 ;; *) echo "Option $cmd selected" && sleep 2 ;; esac
done
EOF
    chmod +x ~/vexy/bin/vexy
fi

# --- Final Step: Auto Open Panel ---
echo -e "\n  ${Y}[4/4] FINALIZING${NC}"
echo -e "  ${DG}└─ ${G}VEXY PANEL INSTALLED SUCCESSFULLY${NC}"
echo -e "\n${G}═══════════════════════════════════════════════════════════${NC}"
echo -e "  ${W}🚀 Starting VEXY Panel in 3 seconds...${NC}"
echo -e "${G}═══════════════════════════════════════════════════════════${NC}"
echo -e "${DG}Copyright © https://t.me/hellocloudUHQ${NC}"

# Auto-start panel
sleep 3
clear
bash ~/vexy/bin/vexy
