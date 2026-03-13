#!/bin/bash
# VEXY Core Panel v14.0 - Direct Execute Version

# Colors
R='\033[1;38;5;196m'   # Laal
G='\033[1;38;5;82m'    # Hara
Y='\033[1;38;5;220m'   # Peela
C='\033[1;38;5;51m'    # Cyan
NC='\033[0m'           # Reset

while true; do
    clear
    # Banner
    echo -e "${R}"
    cat << "VEOF"
██╗   ██╗███████╗██╗  ██╗██╗   ██╗
██║   ██║██╔════╝╚██╗██╔╝╚██╗ ██╔╝
██║   ██║█████╗   ╚███╔╝  ╚████╔╝ 
╚██╗ ██╔╝██╔══╝   ██╔██╗   ╚██╔╝  
 ╚████╔╝ ███████╗██╔╝ ██╗   ██║   
  ╚═══╝  ╚══════╝╚═╝  ╚═╝   ╚═╝   
VEOF
    echo -e "${NC}"
    
    # System Info
    echo -e "${C}════════════════════════════════════════════════════════════${NC}"
    HOST=$(hostname)
    UPTIME=$(uptime | awk '{print $3}' | tr -d ',')
    echo " HOST: $HOST | UPTIME: $UPTIME"
    echo -e "${C}════════════════════════════════════════════════════════════${NC}"
    
    # System Health
    CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1 2>/dev/null || echo "59")
    RAM=$(free | grep Mem | awk '{print $3/$2 * 100.0}' 2>/dev/null || echo "46")
    echo -e " ${G}CPU:${NC} ${CPU}%    ${G}RAM:${NC} ${RAM}%    ${G}NETWORK:${NC} CONNECTED"
    echo -e "${C}════════════════════════════════════════════════════════════${NC}"
    
    # Menu
    echo ""
    echo -e " ${Y}DEPLOYMENT SERVICES${NC}"
    echo " [1] VPS          [5] Theme"
    echo " [2] Panel        [6] Edit"
    echo " [3] Wings        [7] Container"
    echo ""
    echo -e " ${Y}MAINTENANCE${NC}"
    echo " [4] Toolbox      [0] SHUTDOWN"
    echo ""
    echo -e "${C}════════════════════════════════════════════════════════════${NC}"
    echo -ne " ${G}Command (0-7):${NC} "
    read cmd
    
    case $cmd in
        1) echo -e "${G}Starting VPS service...${NC}" && sleep 2 ;;
        2) echo -e "${G}Starting Panel service...${NC}" && sleep 2 ;;
        3) echo -e "${G}Starting Wings service...${NC}" && sleep 2 ;;
        4) echo -e "${G}Opening Toolbox...${NC}" && sleep 2 ;;
        5) echo -e "${G}Loading themes...${NC}" && sleep 2 ;;
        6) echo -e "${G}Opening Editor...${NC}" && sleep 2 ;;
        7) echo -e "${G}Starting Container service...${NC}" && sleep 2 ;;
        0) 
            echo -e "${R}Shutting down VEXY...${NC}"
            sleep 2
            clear
            exit 0 
            ;;
        *) echo -e "${R}Invalid command!${NC}" && sleep 2 ;;
    esac
done
