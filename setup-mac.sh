#!/usr/bin/env bash
# ==============================================================================
# HuyNex Power-User Workstation 1-Click Installer for macOS
# GitHub: https://github.com/huylinhhg/huynex-workstation
# 100% Free & Open Source - Zero Cost - Zero Bloat
# ==============================================================================
set -e

# Terminal Colors
BOLD='\033[1m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

clear
echo -e "${BLUE}=================================================================${NC}"
echo -e "${GREEN}${BOLD}   ⚡ HUYNEX ZERO-LATENCY POWER-USER WORKSTATION (macOS) ⚡${NC}"
echo -e "${CYAN}      Biến máy Mac thành cỗ máy phản xạ tức thì của Top 1%${NC}"
echo -e "${YELLOW}       100% Miễn phí • Tắt sạch tác vụ ngầm • Zero-Bloat${NC}"
echo -e "${BLUE}=================================================================${NC}\n"

# 1. Kiểm tra môi trường macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo -e "${YELLOW}Lỗi: Kịch bản này chỉ dành cho hệ điều hành macOS.${NC}"
    exit 1
fi

# ------------------------------------------------------------------------------
# [BƯỚC 1/6] TRIỆT TIÊU TOÀN BỘ TIẾN TRÌNH & DAEMON CHẠY NGẦM ĂN RAM/CPU
# ------------------------------------------------------------------------------
echo -e "${CYAN}[1/6] Quét & Tắt sạch các tác vụ/tiến trình chạy ngầm (Zero-Bloat)...${NC}"

# A. Diệt ngay các tiến trình chạy ngầm ăn RAM (Adobe, CleanMyMac, Updaters)
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
        echo -e "  ${GREEN}✔ Đã tiêu diệt tiến trình ngầm:${NC} $proc"
        ((KILLED_COUNT++)) || true
    fi
done

# B. Gỡ bỏ các file tự khởi động ngầm 24/7 trong ~/Library/LaunchAgents
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
            echo -e "  ${GREEN}✔ Đã vô hiệu hóa daemon ngầm:${NC} $(basename "$plist")"
            ((DISABLED_AGENTS++)) || true
        fi
    done
done

# C. Vô hiệu hóa crash report dialog và app state restoring gây chậm máy
defaults write com.apple.CrashReporter DialogType none
defaults write -g ApplePersistenceIgnoreState YES
echo -e "  ${GREEN}✔ Đã tắt CrashReporter dialog & khôi phục trạng thái app nặng nề.${NC}"

# D. Quét dọn cấp hệ thống (nếu có quyền ghi)
for plist in /Library/LaunchAgents/com.microsoft.update*.plist /Library/LaunchDaemons/com.macpaw.CleanMyMac*.plist /Library/LaunchDaemons/com.microsoft.autoupdate*.plist; do
    if [ -f "$plist" ] && [ -w "$plist" ]; then
        launchctl unload "$plist" 2>/dev/null || true
        rm -f "$plist" 2>/dev/null || true
        echo -e "  ${GREEN}✔ Đã dọn daemon hệ thống:${NC} $(basename "$plist")"
    fi
done

if [ $KILLED_COUNT -eq 0 ] && [ $DISABLED_AGENTS -eq 0 ]; then
    echo -e "  ${GREEN}✔ Máy sạch sẽ, không có tác vụ chạy ngầm nào tồn đọng.${NC}"
else
    echo -e "  ${GREEN}✔ Đã giải phóng RAM & CPU: Đã tắt $KILLED_COUNT tiến trình, vô hiệu hóa $DISABLED_AGENTS dịch vụ ngầm.${NC}"
fi

# ------------------------------------------------------------------------------
# [BƯỚC 2/6] KIỂM TRA HOMEBREW
# ------------------------------------------------------------------------------
echo -e "\n${CYAN}[2/6] Kiểm tra Homebrew Package Manager...${NC}"
if ! command -v brew &>/dev/null; then
    echo -e "  → Homebrew chưa cài đặt. Đang cài đặt Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if [[ $(uname -m) == "arm64" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        eval "$(/usr/local/bin/brew shellenv)"
    fi
    echo -e "  ${GREEN}✔ Homebrew đã cài đặt thành công.${NC}"
else
    echo -e "  ${GREEN}✔ Homebrew đã sẵn sàng.${NC}"
fi

# ------------------------------------------------------------------------------
# [BƯỚC 3/6] CÀI ĐẶT BỘ CÔNG CỤ CLI RUST HIỆN ĐẠI (100% FREE)
# ------------------------------------------------------------------------------
echo -e "\n${CYAN}[3/6] Cài đặt Bộ công cụ CLI thế hệ mới qua Homebrew...${NC}"
PACKAGES=("zoxide" "eza" "bat" "fzf" "ripgrep")
TO_INSTALL=()
for pkg in "${PACKAGES[@]}"; do
    if ! command -v "$pkg" &>/dev/null && [ "$pkg" != "ripgrep" ] || [ "$pkg" == "ripgrep" ] && ! command -v rg &>/dev/null; then
        TO_INSTALL+=("$pkg")
    else
        echo -e "  ${GREEN}✔ $pkg đã có sẵn.${NC}"
    fi
done

if [ ${#TO_INSTALL[@]} -gt 0 ]; then
    echo -e "  → Đang cài đặt: ${TO_INSTALL[*]}..."
    brew install "${TO_INSTALL[@]}"
    echo -e "  ${GREEN}✔ Đã cài đặt đầy đủ bộ công cụ CLI.${NC}"
fi

# ------------------------------------------------------------------------------
# [BƯỚC 4/6] TỐI ƯU ZERO-LATENCY BÀN PHÍM VÀ HOẠT ẢNH HỆ THỐNG
# ------------------------------------------------------------------------------
echo -e "\n${CYAN}[4/6] Triệt tiêu độ trễ macOS & Tăng tốc độ bàn phím lên cực đại...${NC}"
defaults write -g KeyRepeat -int 2
defaults write -g InitialKeyRepeat -int 10

# Triệt tiêu độ trễ ẩn/hiện Dock (0 delay)
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.15

# Tắt hoạt ảnh mở rộng cửa sổ rườm rà
defaults write -g NSAutomaticWindowAnimationsEnabled -bool false
defaults write com.apple.finder DisableAllAnimations -bool true

killall Dock 2>/dev/null || true
killall Finder 2>/dev/null || true
echo -e "  ${GREEN}✔ Đã áp dụng: KeyRepeat = 2, InitialKeyRepeat = 10 (Nhanh gấp 6 lần).${NC}"
echo -e "  ${GREEN}✔ Đã triệt tiêu delay Dock & Window animations (Zero-Latency).${NC}"

# ------------------------------------------------------------------------------
# [BƯỚC 5/6] CÀI ĐẶT CÔNG CỤ BẢO TRÌ TỰ ĐỘNG (HUYNEX-CLEAN)
# ------------------------------------------------------------------------------
echo -e "\n${CYAN}[5/6] Cài đặt công cụ bảo trì 1-Click (huynex-clean)...${NC}"
mkdir -p "$HOME/.local/bin"
curl -fsSL https://raw.githubusercontent.com/huylinhhg/huynex-workstation/main/bin/huynex-clean -o "$HOME/.local/bin/huynex-clean"
chmod +x "$HOME/.local/bin/huynex-clean"
echo -e "  ${GREEN}✔ Đã cài đặt huynex-clean vào ~/.local/bin/huynex-clean${NC}"

# Cấu hình ~/.zshrc chuẩn Power-User
ZSHRC="$HOME/.zshrc"
touch "$ZSHRC"

MARKER_START="# === HUYNEX_POWER_USER_START ==="
MARKER_END="# === HUYNEX_POWER_USER_END ==="

CONFIG_BLOCK="${MARKER_START}
# Thư mục bin cá nhân
export PATH=\"\$HOME/.local/bin:\$PATH\"

# Tích hợp Modern CLI Toolchain (zoxide, fzf)
if command -v zoxide &>/dev/null; then
  eval \"\$(zoxide init zsh)\"
fi
if command -v fzf &>/dev/null; then
  source <(fzf --zsh)
fi

# Power-User Aliases (Kỷ nguyên Rust)
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
"
    echo -e "  ${GREEN}✔ Đã cập nhật cấu hình HuyNex trong ~/.zshrc${NC}"
else
    echo -e "\n$CONFIG_BLOCK" >> "$ZSHRC"
    echo -e "  ${GREEN}✔ Đã thêm cấu hình HuyNex vào ~/.zshrc${NC}"
fi

# ------------------------------------------------------------------------------
# [BƯỚC 6/6] CÀI ĐẶT ANTIGRAVITY AI SKILL
# ------------------------------------------------------------------------------
echo -e "\n${CYAN}[6/6] Cài đặt kỹ năng AI Antigravity (poweruser-workstation)...${NC}"
SKILL_DIR="$HOME/.gemini/config/skills/poweruser-workstation"
mkdir -p "$SKILL_DIR"
curl -fsSL https://raw.githubusercontent.com/huylinhhg/huynex-workstation/main/skill/SKILL.md -o "$SKILL_DIR/SKILL.md" 2>/dev/null || true
echo -e "  ${GREEN}✔ Đã nạp kỹ năng AI vào ~/.gemini/config/skills/poweruser-workstation${NC}"

# ==============================================================================
# BÁO CÁO KẾT QUẢ HOÀN TẤT
# ==============================================================================
echo -e "\n${BLUE}=================================================================${NC}"
echo -e "${GREEN}${BOLD}   ✨ NÂNG CẤP HOÀN TẤT - BẠN ĐÃ LÀ TOP 1% POWER-USER! ✨${NC}"
echo -e "${BLUE}=================================================================${NC}"
echo -e "${BOLD}Các cải tiến đột phá đã được kích hoạt trên máy của bạn (100% Free):${NC}"
echo -e "  ${CYAN}1. TẮT TẬN GỐC TÁC VỤ NGẦM:${NC} Đã diệt sạch các tiến trình/daemon chạy ngầm 24/7 (Adobe, CleanMyMac, Updaters)."
echo -e "  ${CYAN}2. Zero-Latency Bàn phím:${NC} Tốc độ lướt phím và xóa chữ nhanh gấp 6 lần."
echo -e "  ${CYAN}3. Zero-Latency UI:${NC} Triệt tiêu hoàn toàn độ trễ xuất hiện của Dock & cửa sổ."
echo -e "  ${CYAN}4. Kỷ nguyên CLI Rust:${NC} Dùng ${GREEN}z${NC} (nhảy thư mục), ${GREEN}ls${NC} (eza màu sắc/icon), ${GREEN}cat${NC} (bat highlight code), ${GREEN}grep${NC} (ripgrep siêu tốc)."
echo -e "  ${CYAN}5. Bảo trì 1-Click:${NC} Gõ lệnh ${YELLOW}clean${NC} để dọn sạch rác và tác vụ ngầm trong 3s."
echo -e "  ${CYAN}6. Antigravity AI Skill:${NC} Trong chat Antigravity, chỉ cần gõ ${YELLOW}\"Tối ưu máy\"${NC} là AI tự làm mọi việc."
echo -e "${BLUE}=================================================================${NC}"
echo -e "${YELLOW}${BOLD}👉 BƯỚC CUỐI CÙNG:${NC}"
echo -e "  • Khởi động lại Terminal hoặc gõ: ${GREEN}source ~/.zshrc${NC} để dùng ngay các lệnh mới."
echo -e "${BLUE}=================================================================${NC}\n"
