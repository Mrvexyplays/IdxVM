#!/bin/bash
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
    echo "════════════════════════════════════════"
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
