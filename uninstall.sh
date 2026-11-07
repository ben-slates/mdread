#!/usr/bin/env bash
# ==============================================================================
# mdread Uninstaller
# ==============================================================================

set -e

BOLD="\033[1m"
GREEN="\033[0;32m"
CYAN="\033[0;36m"
YELLOW="\033[1;33m"
RESET="\033[0m"

echo -e "${BOLD}${CYAN}Removing mdread...${RESET}"

REMOVED=0

# Check system location
if [ -f "/usr/local/bin/mdread" ]; then
    if [ "$EUID" -eq 0 ]; then
        rm -f "/usr/local/bin/mdread"
        echo -e "${GREEN}[OK] Removed /usr/local/bin/mdread${RESET}"
        REMOVED=1
    elif command -v sudo >/dev/null 2>&1; then
        sudo rm -f "/usr/local/bin/mdread"
        echo -e "${GREEN}[OK] Removed /usr/local/bin/mdread (via sudo)${RESET}"
        REMOVED=1
    else
        echo -e "${YELLOW}! Found /usr/local/bin/mdread but root privileges are required to delete it.${RESET}"
    fi
fi

# Check user location
if [ -f "$HOME/.local/bin/mdread" ]; then
    rm -f "$HOME/.local/bin/mdread"
    echo -e "${GREEN}[OK] Removed $HOME/.local/bin/mdread${RESET}"
    REMOVED=1
fi

if [ "$REMOVED" -eq 1 ]; then
    echo -e "\n${BOLD}${GREEN}[DONE] mdread has been successfully uninstalled.${RESET}"
else
    echo -e "\n${YELLOW}No installation of mdread was found.${RESET}"
fi
