#!/usr/bin/env bash
# ==============================================================================
# HuyNex Power-User Workstation 1-Click Installer for macOS
# GitHub: https://github.com/huylinhhg/huynex-workstation
# 100% Free - Khong loi font - Kien truc 2 Tang toi uu chuyen sau
# ==============================================================================
set -e

# Terminal Colors
BOLD='\033[1m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

clear
echo -e "${BLUE}=================================================================${NC}"
echo -e "${GREEN}${BOLD}   HUYNEX ZERO-LATENCY POWER-USER WORKSTATION (macOS)${NC}"
echo -e "${CYAN}   Toi uu phan xa, tat tac vu ngam, chong nghen RAM${NC}"
echo -e "${YELLOW}   100% Free - Ma nguon mo - Khong loi font - Zero-Bloat${NC}"
echo -e "${BLUE}=================================================================${NC}\n"

# 1. Kiem tra moi truong macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo -e "${YELLOW}Loi: Kich ban nay chi danh cho he dieu hanh macOS.${NC}"
    exit 1
fi

# ------------------------------------------------------------------------------
# [BUOC 1/6] KIEM TRA TAI NGUYEN RAM VA PHAN TICH TIEN TRINH
# ------------------------------------------------------------------------------
echo -e "${CYAN}[1/6] Kiem tra tai nguyen RAM va phan tich he thong...${NC}"
TOTAL_MEM_BYTES=$(sysctl -n hw.memsize 2>/dev/null || echo 0)
if [ "$TOTAL_MEM_BYTES" -gt 0 ]; then
    TOTAL_MEM_GB=$(awk "BEGIN {printf \"%.2f\", $TOTAL_MEM_BYTES / 1024 / 1024 / 1024}")
    echo -e "  -> Tong RAM may: ${BOLD}${TOTAL_MEM_GB} GB${NC}"
fi

echo -e "  -> Top 5 tien trinh chiem nhieu RAM nhat hien tai:"
ps -axo %mem,rss,comm 2>/dev/null | sort -nr | head -n 5 | while read -r p_mem p_rss p_comm; do
    P_NAME=$(basename "$p_comm")
    P_MB=$(awk "BEGIN {printf \"%.1f\", $p_rss / 1024}")
    echo -e "     * ${P_NAME}: ${P_MB} MB (${p_mem}%)"
done

# ------------------------------------------------------------------------------
# [BUOC 2/6] TANG 1: TU DONG VO HIEU HOA TAC VU NGAM 24/7 (100% AN TOAN)
# ------------------------------------------------------------------------------
echo -e "\n${CYAN}[2/6] [TANG 1] Quet va tat sach cac tac vu/tien trinh chay ngam...${NC}"

BLOAT_PROCESSES=(
    "AdobeIPCBroker"
    "CCLibrary"
    "CoreSync"
    "Adobe Desktop Service"
    "AdobeCRDaemon"
    "CleanMyMac4.HealthMonitor"
    "CleanMyMac4.Menu"
    "CleanMyMac X Updater"
    "GoogleSoftwareUpdateAgent"
    "GoogleUpdater"
    "coccoc_update"
    "Microsoft AU Daemon"
    "Microsoft Update Assistant"
)

KILLED_COUNT=0
for proc in "${BLOAT_PROCESSES[@]}"; do
    if pgrep -fi "$proc" &>/dev/null; then
        pkill -9 -fi "$proc" 2>/dev/null || true
        echo -e "  ${GREEN}✔ Da tieu diet tien trinh ngam:${NC} $proc"
        ((KILLED_COUNT++)) || true
    fi
done

USER_AGENTS=(
    "com.macpaw.CleanMyMac*"
    "com.google.keystone*"
    "com.google.GoogleUpdater*"
    "com.coccoc*"
    "com.adobe.*"
    "com.microsoft.update*"
)

DISABLED_AGENTS=0
for pattern in "${USER_AGENTS[@]}"; do
    for plist in "$HOME/Library/LaunchAgents"/$pattern.plist; do
        if [ -f "$plist" ]; then
            launchctl unload -w "$plist" 2>/dev/null || true
            rm -f "$plist"
            echo -e "  ${GREEN}✔ Da vo hieu hoa daemon ngam:${NC} $(basename "$plist")"
            ((DISABLED_AGENTS++)) || true
        fi
    done
done

defaults write com.apple.CrashReporter DialogType none 2>/dev/null || true
defaults write -g ApplePersistenceIgnoreState YES 2>/dev/null || true
echo -e "  ${GREEN}✔ Da tat hop thoai CrashReporter va khoi phuc app loi gay cham.${NC}"

for plist in /Library/LaunchAgents/com.microsoft.update*.plist /Library/LaunchDaemons/com.macpaw.CleanMyMac*.plist /Library/LaunchDaemons/com.microsoft.autoupdate*.plist; do
    if [ -f "$plist" ] && [ -w "$plist" ]; then
        launchctl unload "$plist" 2>/dev/null || true
        rm -f "$plist" 2>/dev/null || true
        echo -e "  ${GREEN}✔ Da don daemon he thong:${NC} $(basename "$plist")"
    fi
done

if [ $KILLED_COUNT -eq 0 ] && [ $DISABLED_AGENTS -eq 0 ]; then
    echo -e "  ${GREEN}✔ He thong sach se (may moi hoac da toi uu), khong co tac vu ngam ton dong.${NC}"
else
    echo -e "  ${GREEN}✔ Da giai phong RAM & CPU: Tat $KILLED_COUNT tien trinh, vo hieu hoa $DISABLED_AGENTS dich vu ngam.${NC}"
fi

# ------------------------------------------------------------------------------
# [BUOC 3/6] TANG 2: TUY CHON NANG CAO (TINH NANG AN MACOS)
# ------------------------------------------------------------------------------
echo -e "\n${BLUE}=================================================================${NC}"
echo -e "${GREEN}${BOLD}   [TANG 2] TUY CHON TOI UU CAC TINH NANG AN MACOS${NC}"
echo -e "${BLUE}=================================================================${NC}"
echo -e "Cac tinh nang an nay co the giai phong them RAM va hang chuc GB SSD:"
echo -e "  1. Xoa ban sao luu an Time Machine Local Snapshots (Giai phong 10-30 GB SSD)"
echo -e "  2. Tat Chrome chay ngam sau khi dong cua so (Tiet kiem ~500 MB RAM)"
echo -e "  3. Kiem tra danh sach ung dung khoi dong cung may (Login Items)"

echo ""
read -r -p "Ban co muon ap dung cac toi uu an nay khong? (Y/n) [Mac dinh: Y]: " mac_opt
mac_opt=${mac_opt:-y}

if [[ "$mac_opt" =~ ^[Yy]$ ]]; then
    echo -e "\n${CYAN}-> Dang thuc hien toi uu an...${NC}"

    # A. Xoa Time Machine Local Snapshots
    SNAPSHOTS=$(tmutil listlocalsnapshots / 2>/dev/null | grep "com.apple.TimeMachine" || true)
    if [ -n "$SNAPSHOTS" ]; then
        for snap in $SNAPSHOTS; do
            DATE=$(echo "$snap" | cut -d'.' -f4)
            tmutil deletelocalsnapshots "$DATE" 2>/dev/null || true
        done
        echo -e "  ${GREEN}✔ Da xoa cac ban sao luu an Time Machine tren o SSD.${NC}"
    else
        echo -e "  ${GREEN}✔ O SSD sach se, khong co Time Machine Snapshot an nao.${NC}"
    fi

    # B. Tat Google Chrome chay ngam
    defaults write com.google.Chrome BackgroundModeEnabled -bool false 2>/dev/null || true
    echo -e "  ${GREEN}✔ Da tat che do Google Chrome chay ngam khi tat cua so.${NC}"

    # C. Hien thi danh sach Login Items
    LOGIN_ITEMS=$(osascript -e 'tell application "System Events" to get name of every login item' 2>/dev/null || true)
    if [ -n "$LOGIN_ITEMS" ]; then
        echo -e "  -> Cac ung dung dang tu dong mo khi khoi dong may:"
        echo -e "     ${YELLOW}${LOGIN_ITEMS}${NC}"
        echo -e "     (Neu khong can, ban vao System Settings -> General -> Login Items de tat bot)."
    fi
else
    echo -e "-> Da giu nguyen theo y muon cua ban."
fi

# ------------------------------------------------------------------------------
# [BUOC 4/6] KIEM TRA VA CAI DAT HOMEBREW (HO TRO CA MAY TRANG)
# ------------------------------------------------------------------------------
echo -e "\n${CYAN}[4/6] Kiem tra Homebrew Package Manager...${NC}"
if ! command -v brew &>/dev/null; then
    echo -e "  -> May moi (chua co Homebrew). Dang cai dat Homebrew chinh thuc..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if [[ $(uname -m) == "arm64" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        eval "$(/usr/local/bin/brew shellenv)"
    fi
    echo -e "  ${GREEN}✔ Homebrew da cai dat thanh cong.${NC}"
else
    echo -e "  ${GREEN}✔ Homebrew da san sang.${NC}"
fi

# ------------------------------------------------------------------------------
# [BUOC 5/6] CAI DAT BO CONG CU CLI RUST THE HE MOI (100% FREE)
# ------------------------------------------------------------------------------
echo -e "\n${CYAN}[5/6] Cai dat bo cong cu CLI the he moi qua Homebrew...${NC}"
PACKAGES=("zoxide" "eza" "bat" "fzf" "ripgrep")
TO_INSTALL=()
for pkg in "${PACKAGES[@]}"; do
    if ! command -v "$pkg" &>/dev/null && [ "$pkg" != "ripgrep" ] || [ "$pkg" == "ripgrep" ] && ! command -v rg &>/dev/null; then
        TO_INSTALL+=("$pkg")
    else
        echo -e "  ${GREEN}✔ $pkg da co san.${NC}"
    fi
done

if [ ${#TO_INSTALL[@]} -gt 0 ]; then
    echo -e "  -> Dang cai dat: ${TO_INSTALL[*]}..."
    brew install "${TO_INSTALL[@]}"
    echo -e "  ${GREEN}✔ Da cai dat day du bo cong cu CLI.${NC}"
fi

# ------------------------------------------------------------------------------
# [BUOC 6/6] TOI UU ZERO-LATENCY BAN PHIM, PROFILE VA SKILL AI
# ------------------------------------------------------------------------------
echo -e "\n${CYAN}[6/6] Triet tieu do tre ban phim & Hoan tat cau hinh...${NC}"
defaults write -g KeyRepeat -int 2
defaults write -g InitialKeyRepeat -int 10

defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.15

defaults write -g NSAutomaticWindowAnimationsEnabled -bool false
defaults write com.apple.finder DisableAllAnimations -bool true

killall Dock 2>/dev/null || true
killall Finder 2>/dev/null || true
echo -e "  ${GREEN}✔ Da ap dung: KeyRepeat = 2, InitialKeyRepeat = 10 (Nhanh gap 6 lan).${NC}"
echo -e "  ${GREEN}✔ Da triet tieu delay Dock & Window animations (Zero-Latency).${NC}"

mkdir -p "$HOME/.local/bin"
curl -fsSL https://raw.githubusercontent.com/huylinhhg/huynex-workstation/main/bin/huynex-clean -o "$HOME/.local/bin/huynex-clean"
chmod +x "$HOME/.local/bin/huynex-clean"

ZSHRC="$HOME/.zshrc"
touch "$ZSHRC"

MARKER_START="# === HUYNEX_POWER_USER_START ==="
MARKER_END="# === HUYNEX_POWER_USER_END ==="

CONFIG_BLOCK="${MARKER_START}
export PATH=\"\$HOME/.local/bin:\$PATH\"

if command -v zoxide &>/dev/null; then
  eval \"\$(zoxide init zsh)\"
fi
if command -v fzf &>/dev/null; then
  source <(fzf --zsh)
fi

alias cd=\"z\"
alias ls=\"eza --icons --group-directories-first\"
alias ll=\"eza -lah --icons --group-directories-first --git\"
alias lt=\"eza --tree --level=2 --icons\"
alias cat=\"bat --paging=never --style=plain\"
alias catp=\"bat\"
alias grep=\"rg\"
alias clean=\"huynex-clean\"
${MARKER_END}"

if grep -q "$MARKER_START" "$ZSHRC"; then
    python3 -c "
import re
with open('$ZSHRC', 'r') as f: content = f.read()
pattern = re.escape('$MARKER_START') + r'.*?' + re.escape('$MARKER_END')
new_content = re.sub(pattern, '''$CONFIG_BLOCK''', content, flags=re.DOTALL)
with open('$ZSHRC', 'w') as f: f.write(new_content)
" 2>/dev/null || true
    echo -e "  ${GREEN}✔ Da cap nhat cau hinh HuyNex trong ~/.zshrc${NC}"
else
    echo -e "\n$CONFIG_BLOCK" >> "$ZSHRC"
    echo -e "  ${GREEN}✔ Da them cau hinh HuyNex vao ~/.zshrc${NC}"
fi

SKILL_DIR="$HOME/.gemini/config/skills/poweruser-workstation"
mkdir -p "$SKILL_DIR"
curl -fsSL https://raw.githubusercontent.com/huylinhhg/huynex-workstation/main/skill/SKILL.md -o "$SKILL_DIR/SKILL.md" 2>/dev/null || true
echo -e "  ${GREEN}✔ Da nap ky nang AI vao ~/.gemini/config/skills/poweruser-workstation${NC}"

# ==============================================================================
# BAO CAO KET QUA HOAN TAT
# ==============================================================================
echo -e "\n${BLUE}=================================================================${NC}"
echo -e "${GREEN}${BOLD}   NANG CAP HOAN TAT - BAN DA LA TOP 1% POWER-USER!${NC}"
echo -e "${BLUE}=================================================================${NC}"
echo -e "${BOLD}Cac cai tien da duoc kich hoat tren may cua ban (100% Free):${NC}"
echo -e "  ${CYAN}1. TAT SACH TAC VU NGAM:${NC} Da diet cac tien trinh chay ngam 24/7 (Adobe, CleanMyMac, Updaters)."
echo -e "  ${CYAN}2. Zero-Latency Ban phim:${NC} Toc do luot phim va xoa chu nhanh gap 6 lan."
echo -e "  ${CYAN}3. Zero-Latency UI:${NC} Triet tieu hoan toan do tre xuat hien cua Dock va cua so."
echo -e "  ${CYAN}4. Ky nguyen CLI Rust:${NC} Dung ${GREEN}z${NC} (nhay thu muc), ${GREEN}ls${NC} (eza), ${GREEN}cat${NC} (bat), ${GREEN}grep${NC} (rg)."
echo -e "  ${CYAN}5. Bao tri 1-Click:${NC} Go lenh ${YELLOW}clean${NC} de don sach may trong 3s."
echo -e "  ${CYAN}6. Antigravity AI Skill:${NC} Trong chat Antigravity, chi can go ${YELLOW}\"Toi uu may\"${NC}."
echo -e "${BLUE}=================================================================${NC}"
echo -e "${YELLOW}${BOLD}👉 BUOC CUOI CUNG:${NC}"
echo -e "  • Khoi dong lai Terminal hoac go: ${GREEN}source ~/.zshrc${NC} de dung ngay cac lenh moi."
echo -e "${BLUE}=================================================================${NC}\n"
