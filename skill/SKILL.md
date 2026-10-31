---
name: poweruser-workstation
description: Tự động tối ưu hóa toàn diện máy trạm (macOS & Windows) chuẩn Power-User / Zero-Latency UI: Tăng tốc phản hồi bàn phím, loại bỏ rác ngầm, cài đặt bộ công cụ CLI Rust hiện đại (zoxide, eza, bat, fzf, ripgrep), thiết lập Raycast/Profile và dọn dẹp hệ thống định kỳ. LUÔN kích hoạt skill này khi người dùng yêu cầu "tối ưu máy", "dọn dẹp máy", "làm máy mượt hơn", "setup máy chuẩn power user", "tăng tốc bàn phím", hoặc "huynex clean".
---

# HuyNex Power-User Workstation Skill

Kỹ năng tự động hóa tối ưu và quản trị máy trạm hiệu năng cao cho người dùng Antigravity trên macOS và Windows.

## 1. Triết lý vận hành (Core Principles)
- **Zero-Bloat**: Tuyệt đối không để ứng dụng dọn dẹp hoặc updater daemon chạy ngầm 24/7 (như CleanMyMac, CCleaner). Chỉ chạy dọn dẹp theo yêu cầu (on-demand).
- **Zero-Latency UI**: Triệt tiêu độ trễ hoạt ảnh của hệ điều hành, tối đa hóa tốc độ phản hồi phím (`KeyRepeat` tối đa).
- **Modern CLI Toolchain**: Thay thế các công cụ UNIX thập niên 1970 bằng các công cụ viết bằng Rust siêu nhanh (`zoxide`, `eza`, `bat`, `fzf`, `ripgrep`).
- **All-in-One Launcher**: Sử dụng Raycast trên macOS để làm trung tâm điều khiển (Clipboard History, Snippets, Window Management, App Launching).

## 2. Hướng dẫn hành động cho Antigravity Agent

Khi người dùng yêu cầu tối ưu hoặc kiểm tra máy:

### Trên macOS:
1. **Kiểm tra & Tinh chỉnh độ trễ UI**:
   - `defaults write -g KeyRepeat -int 2`
   - `defaults write -g InitialKeyRepeat -int 10`
   - `defaults write com.apple.dock autohide-delay -float 0`
   - `defaults write com.apple.dock autohide-time-modifier -float 0.15`
   - `defaults write -g NSAutomaticWindowAnimationsEnabled -bool false`
   - `defaults write com.apple.finder DisableAllAnimations -bool true`
2. **Kiểm tra tiến trình ngầm**:
   - Rà soát các tiến trình ăn RAM và daemon updater trong `~/Library/LaunchAgents`.
   - Vô hiệu hóa hoặc báo người dùng tắt các dịch vụ giám sát chạy ngầm không cần thiết.
3. **Cài đặt công cụ Power-User qua Homebrew**:
   - Cài đặt: `brew install --cask raycast`
   - Cài đặt: `brew install zoxide eza bat fzf ripgrep`
4. **Cấu hình shell `~/.zshrc`**:
   - Nạp `zoxide init zsh` và `fzf --zsh`.
   - Thiết lập alias: `cd -> z`, `ls -> eza --icons --group-directories-first`, `ll -> eza -lah --icons --group-directories-first --git`, `cat -> bat --paging=never --style=plain`, `grep -> rg`.
5. **Chạy dọn dẹp hệ thống**:
   - Chạy lệnh `huynex-clean` để giải phóng bộ nhớ đệm, cache dev và thùng rác.

### Trên Windows:
1. **Tối ưu tốc độ bàn phím trong Registry**:
   - `Set-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name "KeyboardSpeed" -Value 31`
   - `Set-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name "KeyboardDelay" -Value 0`
2. **Cài đặt công cụ qua winget**:
   - `winget install ajeetdsouza.zoxide --source winget --accept-source-agreements --accept-package-agreements`
   - `winget install eza-community.eza --source winget --accept-source-agreements --accept-package-agreements`
   - `winget install sharkdp.bat --source winget --accept-source-agreements --accept-package-agreements`
   - `winget install junegunn.fzf --source winget --accept-source-agreements --accept-package-agreements`
   - `winget install BurntSushi.ripgrep.MSVC --source winget --accept-source-agreements --accept-package-agreements`
3. **Cấu hình PowerShell Profile ($PROFILE)**:
   - Thêm khối cấu hình `zoxide`, alias `cd`, `ls`, `ll`, `cat`, `grep`.
4. **Bảo trì**:
   - Chạy kịch bản `huynex-clean.ps1` để dọn sạch `%TEMP%`, npm/pip cache và Recycle Bin.
