#!/usr/bin/env bash
# ==============================================================================
# mdread Installer - Installs mdread CLI Markdown Reader for any user / system
# ==============================================================================

set -e

# ANSI Color codes
BOLD="\033[1m"
GREEN="\033[0;32m"
CYAN="\033[0;36m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
RESET="\033[0m"

echo -e "${BOLD}${CYAN}"
echo "================================================="
echo "        mdread CLI Installer & Setup             "
echo "================================================="
echo -e "${RESET}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BINARY_SOURCE="$SCRIPT_DIR/mdread"

if [ ! -f "$BINARY_SOURCE" ]; then
    echo -e "${RED}[ERROR] Source binary '$BINARY_SOURCE' not found!${RESET}"
    exit 1
fi

# 1. Check Python 3
echo -e "${BOLD}--> [1/4] Checking Python 3...${RESET}"
if ! command -v python3 >/dev/null 2>&1; then
    echo -e "${RED}[ERROR] Python 3 is not installed.${RESET}"
    echo "Please install Python 3 (e.g. 'sudo apt install python3' or 'brew install python3') and rerun this script."
    exit 1
fi
PYTHON_VERSION=$(python3 --version 2>&1)
echo -e "    ${GREEN}Found:${RESET} $PYTHON_VERSION"

# 2. Check and Install dependencies (rich & textual)
echo -e "\n${BOLD}--> [2/4] Checking Python dependencies (rich & textual)...${RESET}"
DEPS_MISSING=0
if ! python3 -c "import rich, textual" >/dev/null 2>&1; then
    DEPS_MISSING=1
fi

if [ "$DEPS_MISSING" -eq 0 ]; then
    echo -e "    ${GREEN}[OK] 'rich' and 'textual' are already installed.${RESET}"
else
    echo -e "    ${YELLOW}Installing required dependencies (rich & textual)...${RESET}"
    INSTALLED=0

    # Try pip from requirements.txt
    if python3 -m pip install -r "$SCRIPT_DIR/requirements.txt" >/dev/null 2>&1; then
        INSTALLED=1
    elif python3 -m pip install -r "$SCRIPT_DIR/requirements.txt" --break-system-packages >/dev/null 2>&1; then
        INSTALLED=1
    elif python3 -m pip install rich textual --break-system-packages >/dev/null 2>&1; then
        INSTALLED=1
    fi

    if python3 -c "import rich, textual" >/dev/null 2>&1; then
        echo -e "    ${GREEN}[OK] Successfully installed all dependencies!${RESET}"
    else
        echo -e "${YELLOW}[WARNING] Could not auto-install dependencies.${RESET}"
        echo -e "Please install them via: ${BOLD}pip install rich textual${RESET}"
    fi
fi

# 3. Determine Installation Destination
echo -e "\n${BOLD}--> [3/4] Installing executable...${RESET}"
if [ "$EUID" -eq 0 ]; then
    # Running as root: System-wide install for ALL users
    INSTALL_DIR="/usr/local/bin"
    echo -e "    Installing system-wide to: ${CYAN}$INSTALL_DIR${RESET}"
else
    # Running as normal user
    INSTALL_DIR="$HOME/.local/bin"
    mkdir -p "$INSTALL_DIR"
    echo -e "    Installing to user bin: ${CYAN}$INSTALL_DIR${RESET}"
fi

TARGET="$INSTALL_DIR/mdread"
cp "$BINARY_SOURCE" "$TARGET"
chmod +x "$TARGET"
echo -e "    ${GREEN}[OK] Copied mdread to $TARGET and made executable.${RESET}"

# 4. Check PATH
echo -e "\n${BOLD}--> [4/4] Verifying PATH environment...${RESET}"
PATH_OK=0
IFS=':' read -ra ADDR <<< "$PATH"
for p in "${ADDR[@]}"; do
    if [ "$p" = "$INSTALL_DIR" ]; then
        PATH_OK=1
        break
    fi
done

if [ "$PATH_OK" -eq 1 ]; then
    echo -e "    ${GREEN}[OK] $INSTALL_DIR is already in your PATH!${RESET}"
else
    echo -e "    ${YELLOW}! Note: '$INSTALL_DIR' is not currently in your \$PATH.${RESET}"
    echo -e "    To use 'mdread' from anywhere, add this to your ${BOLD}~/.bashrc${RESET} or ${BOLD}~/.zshrc${RESET}:"
    echo -e "      ${BOLD}export PATH=\"$INSTALL_DIR:\$PATH\"${RESET}"
fi

# Verification
echo -e "\n${BOLD}${GREEN}================================================="
echo "      [DONE] mdread has been successfully installed!  "
echo "================================================="
echo -e "${RESET}"

echo -e "Quick test commands (click or copy to paste):"
echo -e "  mdread README.md"
echo -e "  mdread -c README.md"
echo -e "  mdread --help\n"
