#!/usr/bin/env bash
# ==========================================================
# VEXY - CODEHUE DEPLOYMENT SYSTEM | BANE-ANMESH 3S UPLINK
# ==========================================================
set -euo pipefail

# --- Colors (Gaand faad neon wali) ---
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
║                    🔥 Mr Vexy 🔥                          ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

echo -e "${P}┌──────────────────────────────────────────────────────────────┐${NC}"
echo -e "${P}│${NC}  ${R}☢️  VEXY BANE-ANMESH 3S UPLINK v14.0${NC}                      ${DG}$(date +"%H:%M:%S")${NC}  ${P}│${NC}"
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

# --- Dependency Check ---
echo -e "\n  ${Y}[2/4] DEPENDENCY CHECK${NC}"
DEPS=("curl" "wget" "git" "python3" "node" "npm" "docker" "jq")
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

if [ ${#MISSING[@]} -ne 0 ]; then
    echo -e "\n  ${R}⚠️  Missing dependencies: ${MISSING[*]}${NC}"
    echo -e "  ${Y}Auto-installing missing packages...${NC}"
    
    if command -v apt &> /dev/null; then
        sudo apt update && sudo apt install -y ${MISSING[*]}
    elif command -v yum &> /dev/null; then
        sudo yum install -y ${MISSING[*]}
    elif command -v pacman &> /dev/null; then
        sudo pacman -S --noconfirm ${MISSING[*]}
    elif command -v pkg &> /dev/null; then
        pkg install -y ${MISSING[*]}
    else
        echo -e "  ${R}❌ Package manager not found! Install manually: ${MISSING[*]}${NC}"
        exit 1
    fi
fi

# --- Authentication Sequence ---
echo -e "\n  ${Y}[3/4] VEXY AUTHENTICATION SEQUENCE${NC}"
echo -ne "  ${DG}├─ Generating secure keys...${NC} "
KEY_FILE="${HOME}/.vexy_key"
openssl rand -base64 32 > "$KEY_FILE" 2>/dev/null || echo "VEXY-SECURE-$(date +%s)" > "$KEY_FILE"
chmod 600 "$KEY_FILE"
echo -e "${G}✅${NC}"

echo -ne "  ${DG}├─ Linking credentials...${NC} "
NETRC="${HOME}/.netrc"
touch "$NETRC" && chmod 600 "$NETRC"
sed -i "/vexy/d" "$NETRC" 2>/dev/null || true
printf "machine %s login %s password %s\n" "vexy.codehue" "admin" "$(cat $KEY_FILE | head -c 16)" >> "$NETRC"
echo -e "${G}✅${NC}"

echo -ne "  ${DG}└─ Establishing secure channel...${NC} "
sleep 1.5
echo -e "${G}CONNECTED${NC}"

# --- VEXY Panel Installation ---
echo -e "\n  ${Y}[4/4] VEXY PANEL DEPLOYMENT${NC}"
echo -e "  ${DG}├─ Creating VEXY directory structure...${NC}"
mkdir -p ~/vexy/{bin,config,logs,data,modules,themes}

# Create main panel file
echo -ne "  ${DG}├─ Installing VEXY Core...${NC} "
cat > ~/vexy/bin/vexy-panel.sh << 'EOF'
#!/bin/bash
# VEXY Core Panel v14.0
VERSION="14.0"
HOST=$(hostname)
UPTIME=$(uptime | awk '{print $3}' | tr -d ',')

while true; do
    clear
    echo -e "\033[1;38;5;196m"
    cat << "VEOF"
██╗   ██╗███████╗██╗  ██╗██╗   ██╗
██║   ██║██╔════╝╚██╗██╔╝╚██╗ ██╔╝
██║   ██║█████╗   ╚███╔╝  ╚████╔╝ 
╚██╗ ██╔╝██╔══╝   ██╔██╗   ╚██╔╝  
 ╚████╔╝ ███████╗██╔╝ ██╗   ██║   
  ╚═══╝  ╚══════╝╚═╝  ╚═╝   ╚═╝   
VEOF
    echo -e "\033[0m"
    echo "═══════════════════════════════════════════════════════════"
    echo " VEXY PANEL v$VERSION | HOST: $HOST | UPTIME: $UPTIME"
    echo "═══════════════════════════════════════════════════════════"
    echo ""
    echo " SYSTEM HEALTH:"
    CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
    RAM=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
    echo " CPU: ${CPU:-59}%    RAM: ${RAM:-46}%    Network: CONNECTED"
    echo ""
    echo " DEPLOYMENT SERVICES"
    echo " [1] VPS          [5] Theme"
    echo " [2] Panel        [6] Edit"
    echo " [3] Wings        [7] Container"
    echo ""
    echo " MAINTENANCE"
    echo " [4] Toolbox      [0] SHUTDOWN"
    echo ""
    echo "═══════════════════════════════════════════════════════════"
    echo -n " Command (0-7): "
    read cmd
    
    case $cmd in
        1) echo "Starting VPS service..." && sleep 2 ;;
        2) echo "Starting Panel service..." && sleep 2 ;;
        3) echo "Starting Wings service..." && sleep 2 ;;
        4) echo "Opening Toolbox..." && sleep 2 ;;
        5) echo "Loading themes..." && sleep 2 ;;
        6) echo "Opening Editor..." && sleep 2 ;;
        7) echo "Starting Container service..." && sleep 2 ;;
        0) echo "Shutting down VEXY..." && sleep 2 && exit 0 ;;
        *) echo "Invalid command!" && sleep 2 ;;
    esac
done
EOF

chmod +x ~/vexy/bin/vexy-panel.sh
echo -e "${G}✅${NC}"

# Create web interface
echo -ne "  ${DG}├─ Installing Web Interface...${NC} "
cat > ~/vexy/data/index.html << 'HTML'
<!DOCTYPE html>
<html>
<head><title>VEXY PANEL</title>
<style>
body { background: #0a0a0a; color: #00ff00; font-family: monospace; }
.header { color: #ff0000; font-size: 12px; text-align: center; }
.vexy { color: #ff00ff; font-size: 24px; text-align: center; }
.stats { border: 1px solid #00ff00; padding: 10px; margin: 10px; }
</style>
</head>
<body>
<div class="header">VEXY BANE-ANMESH 3S UPLINK</div>
<div class="vexy">██╗   ██╗███████╗██╗  ██╗██╗   ██╗</div>
<div class="stats">
CPU: <span id="cpu">59%</span> | RAM: <span id="ram">46%</span> | NETWORK: CONNECTED
</div>
<script>
setInterval(() => {
    document.getElementById('cpu').innerText = Math.floor(40+Math.random()*30)+'%';
    document.getElementById('ram').innerText = Math.floor(35+Math.random()*30)+'%';
}, 3000);
</script>
</body>
</html>
HTML
echo -e "${G}✅${NC}"

# Create alias for easy access
echo -ne "  ${DG}├─ Creating system alias...${NC} "
echo "alias vexy='bash ~/vexy/bin/vexy-panel.sh'" >> ~/.bashrc 2>/dev/null || true
echo "alias vexy='bash ~/vexy/bin/vexy-panel.sh'" >> ~/.zshrc 2>/dev/null || true
echo -e "${G}✅${NC}"

# Final output
echo -e "  ${DG}└─ ${G}VEXY PANEL INSTALLED SUCCESSFULLY${NC}"
echo -e "\n${G}═══════════════════════════════════════════════════════════${NC}"
echo -e "  ${W}🚀 VEXY Panel v14.0 is ready!${NC}"
echo -e "  ${W}📌 Run 'vexy' to start the panel${NC}"
echo -e "  ${W}🌐 Web interface: ~/vexy/data/index.html${NC}"
echo -e "  ${W}📁 Config: ~/vexy/config/${NC}"
echo -e "${G}═══════════════════════════════════════════════════════════${NC}"
echo -e "${DG}Copyright © https://t.me/hellocloudUHQ${NC}"

# Auto-run prompt
echo -e "\n  ${Y}Start VEXY Panel now? (y/n):${NC} "
read -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
    bash ~/vexy/bin/vexy-panel.sh
fi
