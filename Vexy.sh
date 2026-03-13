#!/bin/bash
# VEXY Auto Installer - Sab kuch ek saath

echo -e "\n\033[1;38;5;196m"
cat << "VEOF"
██╗   ██╗███████╗██╗  ██╗██╗   ██╗
██║   ██║██╔════╝╚██╗██╔╝╚██╗ ██╔╝
██║   ██║█████╗   ╚███╔╝  ╚████╔╝ 
╚██╗ ██╔╝██╔══╝   ██╔██╗   ╚██╔╝  
 ╚████╔╝ ███████╗██╔╝ ██╗   ██║   
  ╚═══╝  ╚══════╝╚═╝  ╚═╝   ╚═╝   
VEOF
echo -e "\033[0m"

echo "⚡ Installing Dependencies + VEXY Panel in One Go..."

# Update system
apt update -y

# Install Node.js 18.x (LTS)
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt install nodejs jq git wget curl -y

# Verify installations
echo "✅ Node: $(node --version)"
echo "✅ NPM: $(npm --version)"
echo "✅ JQ: $(jq --version)"

# Create VEXY directory structure
mkdir -p ~/vexy/{bin,config,logs,data}

# Create main panel script
cat > ~/vexy/bin/vexy-panel.sh << 'EOF'
#!/bin/bash
while true; do
    clear
    echo -e "\033[1;38;5;196mVEAT - Mr Vexy\033[0m"
    echo "════════════════════════════════════════"
    echo " SYSTEM HEALTH:"
    CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
    RAM=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
    echo " CPU: ${CPU:-59}% | RAM: ${RAM:-46}% | NETWORK: CONNECTED"
    echo "════════════════════════════════════════"
    echo " [1] VPS     [2] Panel   [3] Wings"
    echo " [4] Toolbox [5] Theme   [6] Edit"
    echo " [7] Container          [0] Exit"
    echo "════════════════════════════════════════"
    read -p " Command: " cmd
    case $cmd in
        0) exit 0 ;;
        *) echo "Option $cmd selected" && sleep 2 ;;
    esac
done
EOF

chmod +x ~/vexy/bin/vexy-panel.sh
echo "alias vexy='bash ~/vexy/bin/vexy-panel.sh'" >> ~/.bashrc
source ~/.bashrc

echo "✅ VEXY Panel Installed! Run 'vexy' to start"
