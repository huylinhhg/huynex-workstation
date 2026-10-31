---
name: poweruser-workstation
description: Tự động tối ưu hóa toàn diện máy trạm (macOS & Windows) chuẩn Power-User / Zero-Latency UI: Tắt tận gốc các tác vụ và daemon chạy ngầm (Adobe, CleanMyMac, Updaters, Telemetry), tăng tốc phản hồi bàn phím, cài đặt bộ công cụ CLI Rust hiện đại 100% miễn phí (zoxide, eza, bat, fzf, ripgrep), thiết lập Profile và dọn dẹp hệ thống định kỳ. LUÔN kích hoạt skill này khi người dùng yêu cầu "tối ưu máy", "dọn dẹp máy", "tắt tác vụ ngầm", "làm máy mượt hơn", "setup máy chuẩn power user", "tăng tốc bàn phím", hoặc "huynex clean".
---

# HuyNex Power-User Workstation Skill

Kỹ năng tự động hóa tối ưu và quản trị máy trạm hiệu năng cao cho người dùng Antigravity trên macOS và Windows. Hoàn toàn 100% miễn phí, mã nguồn mở, không thuê bao, không phần mềm trả phí.

## 1. Triết lý vận hành (Core Principles)
- **Zero-Bloat & Zero-Daemon**: Tuyệt đối loại bỏ và vô hiệu hóa các tiến trình/daemon chạy ngầm 24/7 (Adobe CCLibrary/IPCBroker, CleanMyMac HealthMonitor/Updater, Google Software Update, Cốc Cốc, Edge, Microsoft AutoUpdate, Telemetry).
- **Zero-Latency UI**: Triệt tiêu độ trễ hoạt ảnh của hệ điều hành, tối đa hóa tốc độ phản hồi phím (`KeyRepeat` tối đa).
- **Modern CLI Toolchain**: Trang bị bộ công cụ mã nguồn mở viết bằng Rust siêu nhanh, miễn phí vĩnh viễn (`zoxide`, `eza`, `bat`, `fzf`, `ripgrep`).

## 2. Hướng dẫn hành động cho Antigravity Agent

Khi người dùng yêu cầu tối ưu hoặc kiểm tra máy:

### Trên macOS:
1. **Quét & Tắt sạch tác vụ ngầm (Zero-Bloat)**:
   - Diệt tiến trình ngầm ăn tài nguyên: `pkill -9 -fi "AdobeIPCBroker"`, `CCLibrary`, `CoreSync`, `CleanMyMac4`, `GoogleSoftwareUpdateAgent`, `coccoc_update`.
   - Gỡ bỏ LaunchAgents ngầm trong `~/Library/LaunchAgents/` (`com.macpaw.*`, `com.google.*`, `com.coccoc.*`, `com.adobe.*`).
   - Tắt CrashReporter dialog: `defaults write com.apple.CrashReporter DialogType none`.
2. **Kiểm tra & Tinh chỉnh độ trễ UI**:
   - `defaults write -g KeyRepeat -int 2`
   - `defaults write -g InitialKeyRepeat -int 10`
   - `defaults write com.apple.dock autohide-delay -float 0`
   - `defaults write com.apple.dock autohide-time-modifier -float 0.15`
   - `defaults write -g NSAutomaticWindowAnimationsEnabled -bool false`
   - `defaults write com.apple.finder DisableAllAnimations -bool true`
3. **Cài đặt công cụ Power-User qua Homebrew (100% Free & Open Source)**:
   - `brew install zoxide eza bat fzf ripgrep`
4. **Cấu hình shell `~/.zshrc`**:
   - Nạp `zoxide init zsh` và `fzf --zsh`.
   - Thiết lập alias: `cd -> z`, `ls -> eza --icons --group-directories-first`, `ll -> eza -lah --icons --group-directories-first --git`, `cat -> bat --paging=never --style=plain`, `grep -> rg`.
5. **Chạy dọn dẹp hệ thống**:
   - Chạy lệnh `huynex-clean` để giải phóng bộ nhớ đệm, cache dev và thùng rác.

### Trên Windows:
1. **Vô hiệu hóa dịch vụ & tiến trình chạy ngầm**:
   - Tắt và vô hiệu hóa service: `gupdate`, `gupdatem`, `edgeupdate`, `edgeupdatem`, `AdobeARMservice`, `DiagTrack` (Telemetry).
   - Đóng tiến trình ngầm: `GoogleUpdate.exe`, `MicrosoftEdgeUpdate.exe`, `AdobeARM.exe`.
   - Tắt Windows Telemetry trong Registry: `HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection` `AllowTelemetry = 0`.
   - Tắt Bing Search ngầm: `HKCU:\Software\Microsoft\Windows\CurrentVersion\Search` `BingSearchEnabled = 0`.
2. **Tối ưu tốc độ bàn phím trong Registry**:
   - `Set-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name "KeyboardSpeed" -Value 31`
   - `Set-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name "KeyboardDelay" -Value 0`
3. **Cài đặt công cụ qua winget (100% Free & Open Source)**:
   - `winget install ajeetdsouza.zoxide --source winget`
   - `winget install eza-community.eza --source winget`
   - `winget install sharkdp.bat --source winget`
   - `winget install junegunn.fzf --source winget`
   - `winget install BurntSushi.ripgrep.MSVC --source winget`
4. **Cấu hình PowerShell Profile ($PROFILE)**:
   - Thêm khối cấu hình `zoxide`, alias `cd`, `ls`, `ll`, `cat`, `grep`.
5. **Bảo trì**:
   - Chạy kịch bản `huynex-clean.ps1` để dọn sạch `%TEMP%`, npm/pip cache và Recycle Bin.
