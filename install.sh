#!/usr/bin/env bash
# ==============================================================================
# HuyNex Power-User Workstation 1-Click Installer for macOS
# GitHub: https://github.com/huylinhhg/huynex-poweruser
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
echo -e "${BLUE}=================================================================${NC}\n"

# 1. Kiểm tra môi trường macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo -e "${YELLOW}Lỗi: Kịch bản này chỉ dành cho hệ điều hành macOS.${NC}"
    exit 1
fi

# 2. Kiểm tra và chuẩn bị Homebrew
echo -e "${CYAN}[1/6] Kiểm tra Homebrew Package Manager...${NC}"
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

# 3. Cài đặt Raycast & Modern CLI Tools (Kỷ nguyên Rust)
echo -e "\n${CYAN}[2/6] Cài đặt Raycast & Bộ công cụ CLI thế hệ mới qua Homebrew...${NC}"
# Raycast
if [ -d "/Applications/Raycast.app" ]; then
    echo -e "  ${GREEN}✔ Raycast.app đã có sẵn.${NC}"
else
    echo -e "  → Đang cài đặt Raycast qua Homebrew Cask..."
    brew install --cask raycast
    echo -e "  ${GREEN}✔ Đã cài đặt Raycast.app${NC}"
fi

# Modern CLI tools
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

# 4. Kích hoạt Zero-Latency UI & Tối đa tốc độ bàn phím
echo -e "\n${CYAN}[3/6] Triệt tiêu độ trễ macOS & Đẩy tốc độ gõ phím lên cực đại...${NC}"
# Tốc độ lướt phím và xóa chữ siêu nhanh
defaults write -g KeyRepeat -int 2
defaults write -g InitialKeyRepeat -int 10

# Triệt tiêu độ trễ ẩn/hiện Dock (0 delay)
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.15

# Tắt hoạt ảnh mở rộng cửa sổ rườm rà
defaults write -g NSAutomaticWindowAnimationsEnabled -bool false
defaults write com.apple.finder DisableAllAnimations -bool true

# Áp dụng thay đổi tức thì
killall Dock 2>/dev/null || true
killall Finder 2>/dev/null || true
echo -e "  ${GREEN}✔ Đã áp dụng: KeyRepeat = 2, InitialKeyRepeat = 10 (Nhanh gấp 6 lần).${NC}"
echo -e "  ${GREEN}✔ Đã triệt tiêu delay Dock & Window animations (Zero-Latency).${NC}"

# 5. Cài đặt kịch bản bảo trì tự động huynex-clean
echo -e "\n${CYAN}[4/6] Cài đặt công cụ bảo trì 1-Click (huynex-clean)...${NC}"
mkdir -p "$HOME/.local/bin"
curl -fsSL https://raw.githubusercontent.com/huylinhhg/huynex-poweruser/main/bin/huynex-clean -o "$HOME/.local/bin/huynex-clean"
chmod +x "$HOME/.local/bin/huynex-clean"
echo -e "  ${GREEN}✔ Đã cài đặt huynex-clean vào ~/.local/bin/huynex-clean${NC}"

# 6. Cấu hình ~/.zshrc chuẩn Power-User
echo -e "\n${CYAN}[5/6] Cấu hình Shell Profile (~/.zshrc)...${NC}"
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
    # Thay thế khối cũ
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

# 7. Cài đặt Antigravity Skill
echo -e "\n${CYAN}[6/6] Cài đặt Antigravity Skill (poweruser-workstation)...${NC}"
SKILL_DIR="$HOME/.gemini/config/skills/poweruser-workstation"
mkdir -p "$SKILL_DIR"
curl -fsSL https://raw.githubusercontent.com/huylinhhg/huynex-poweruser/main/skill/SKILL.md -o "$SKILL_DIR/SKILL.md"
echo -e "  ${GREEN}✔ Đã cài đặt skill vào $SKILL_DIR/SKILL.md${NC}"

# Mở Raycast nếu chưa chạy
if [ -d "/Applications/Raycast.app" ]; then
    open -a "Raycast" 2>/dev/null || true
fi

# ==============================================================================
# BÁO CÁO KẾT QUẢ HOÀN TẤT
# ==============================================================================
echo -e "\n${BLUE}=================================================================${NC}"
echo -e "${GREEN}${BOLD}   ✨ NÂNG CẤP HOÀN TẤT - BẠN ĐÃ LÀ TOP 1% POWER-USER! ✨${NC}"
echo -e "${BLUE}=================================================================${NC}"
echo -e "${BOLD}Các cải tiến đã được kích hoạt trên máy của bạn:${NC}"
echo -e "  ${CYAN}1. Zero-Latency Bàn phím:${NC} Tốc độ lướt phím và xóa chữ nhanh gấp 6 lần."
echo -e "  ${CYAN}2. Zero-Latency UI:${NC} Triệt tiêu hoàn toàn độ trễ xuất hiện của Dock & cửa sổ."
echo -e "  ${CYAN}3. Trung tâm điều khiển Raycast:${NC} Đã cài đặt Raycast.app (thay thế Spotlight)."
echo -e "  ${CYAN}4. Kỷ nguyên CLI Rust:${NC} Dùng ${GREEN}z${NC} (nhảy thư mục), ${GREEN}ls${NC} (eza màu sắc/icon), ${GREEN}cat${NC} (bat highlight code), ${GREEN}grep${NC} (ripgrep siêu tốc)."
echo -e "  ${CYAN}5. Bảo trì 1-Click:${NC} Gõ lệnh ${YELLOW}huynex-clean${NC} hoặc ${YELLOW}clean${NC} để dọn sạch máy trong 3s."
echo -e "  ${CYAN}6. Antigravity AI Skill:${NC} Trong chat Antigravity, bạn chỉ cần gõ ${YELLOW}\"Tối ưu máy\"${NC} là AI tự làm mọi việc."
echo -e "${BLUE}=================================================================${NC}"
echo -e "${YELLOW}${BOLD}👉 BƯỚC CUỐI CÙNG (Khuyến nghị):${NC}"
echo -e "  • Khởi động lại Terminal hoặc gõ: ${GREEN}source ~/.zshrc${NC} để dùng ngay các lệnh mới."
echo -e "  • Vào ${BOLD}Cài đặt hệ thống${NC} → ${BOLD}Bàn phím${NC} → ${BOLD}Phím tắt${NC} → Tắt Spotlight (Cmd+Space) và gán ${GREEN}Cmd + Space${NC} cho Raycast."
echo -e "${BLUE}=================================================================${NC}\n"
