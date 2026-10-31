<#
.SYNOPSIS
    HuyNex Power-User Workstation 1-Click Installer for Windows
    GitHub: https://github.com/huylinhhg/huynex-poweruser
.DESCRIPTION
    Tối ưu hóa bàn phím Zero-Latency, cài đặt bộ công cụ CLI Rust hiện đại,
    cấu hình PowerShell Profile và cài đặt Antigravity Skill.
#>

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$Host.UI.RawUI.ForegroundColor = "Cyan"
Write-Host "================================================================="
Write-Host "   ⚡ HUYNEX ZERO-LATENCY POWER-USER WORKSTATION (Windows) ⚡" -ForegroundColor Green
Write-Host "      Biến máy Windows thành cỗ máy phản xạ tức thì của Top 1%" -ForegroundColor White
Write-Host "================================================================="
$Host.UI.RawUI.ForegroundColor = "White"

# 1. Tối ưu bàn phím Zero-Latency (HKCU không cần quyền Admin)
Write-Host "`n[1/5] Tối ưu tốc độ phản hồi bàn phím (Zero-Latency UI)..." -ForegroundColor Yellow
try {
    Set-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name "KeyboardSpeed" -Value 31 -Force
    Set-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name "KeyboardDelay" -Value 0 -Force
    Write-Host "  ✔ Đã thiết lập KeyboardSpeed = 31, KeyboardDelay = 0 (tốc độ tối đa)" -ForegroundColor Green
} catch {
    Write-Host "  ⚠ Không thể chỉnh Registry: $($_.Exception.Message)" -ForegroundColor Red
}

# 2. Cài đặt các công cụ CLI hiện đại qua winget
Write-Host "`n[2/5] Kiểm tra và cài đặt bộ công cụ CLI Rust qua winget..." -ForegroundColor Yellow
if (Get-Command winget -ErrorAction SilentlyContinue) {
    $packages = @(
        @{ Name = "zoxide"; Id = "ajeetdsouza.zoxide"; CheckCmd = "zoxide" },
        @{ Name = "eza"; Id = "eza-community.eza"; CheckCmd = "eza" },
        @{ Name = "bat"; Id = "sharkdp.bat"; CheckCmd = "bat" },
        @{ Name = "fzf"; Id = "junegunn.fzf"; CheckCmd = "fzf" },
        @{ Name = "ripgrep"; Id = "BurntSushi.ripgrep.MSVC"; CheckCmd = "rg" }
    )

    foreach ($pkg in $packages) {
        if (Get-Command $pkg.CheckCmd -ErrorAction SilentlyContinue) {
            Write-Host "  ✔ $($pkg.Name) đã có sẵn." -ForegroundColor Green
        } else {
            Write-Host "  → Đang cài đặt $($pkg.Name)..." -ForegroundColor Cyan
            winget install --id $pkg.Id --exact --source winget --accept-source-agreements --accept-package-agreements --silent --no-upgrade | Out-Null
            Write-Host "  ✔ Đã cài đặt $($pkg.Name)" -ForegroundColor Green
        }
    }
} else {
    Write-Host "  ⚠ Không tìm thấy winget! Vui lòng cập nhật App Installer từ Microsoft Store." -ForegroundColor Red
}

# 3. Cài đặt kịch bản bảo trì huynex-clean.ps1
Write-Host "`n[3/5] Cài đặt công cụ bảo trì 1-Click (huynex-clean.ps1)..." -ForegroundColor Yellow
$binDir = "$HOME\.local\bin"
if (!(Test-Path $binDir)) { New-Item -ItemType Directory -Path $binDir -Force | Out-Null }
$cleanScriptUrl = "https://raw.githubusercontent.com/huylinhhg/huynex-poweruser/main/bin/huynex-clean.ps1"
Invoke-WebRequest -Uri $cleanScriptUrl -OutFile "$binDir\huynex-clean.ps1"
Write-Host "  ✔ Đã tải huynex-clean.ps1 vào $binDir\huynex-clean.ps1" -ForegroundColor Green

# 4. Cấu hình PowerShell Profile ($PROFILE)
Write-Host "`n[4/5] Cấu hình PowerShell Profile ($PROFILE)..." -ForegroundColor Yellow
$profilePath = $PROFILE
$profileDir = Split-Path $profilePath -Parent
if (!(Test-Path $profileDir)) { New-Item -ItemType Directory -Path $profileDir -Force | Out-Null }

$markerStart = "# === HUYNEX_POWER_USER_START ==="
$markerEnd = "# === HUYNEX_POWER_USER_END ==="

$profileBlock = @"
$markerStart
# Modern CLI Toolchain (zoxide, fzf)
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
}

Set-Alias -Name cd -Value z -Option AllScope -ErrorAction SilentlyContinue
function ls { eza --icons --group-directories-first `$args }
function ll { eza -lah --icons --group-directories-first --git `$args }
function cat { bat --paging=never --style=plain `$args }
Set-Alias -Name grep -Value rg -Option AllScope -ErrorAction SilentlyContinue

function clean { & "`$HOME\.local\bin\huynex-clean.ps1" }
function huynex-clean { & "`$HOME\.local\bin\huynex-clean.ps1" }
$markerEnd
"@

$currentProfile = ""
if (Test-Path $profilePath) {
    $currentProfile = Get-Content -Path $profilePath -Raw -Encoding UTF8
}

$startEsc = [regex]::Escape($markerStart)
$endEsc = [regex]::Escape($markerEnd)
if ($currentProfile -match $startEsc) {
    $currentProfile = [regex]::Replace($currentProfile, "(?s)$startEsc.*?$endEsc", $profileBlock)
    Set-Content -Path $profilePath -Value $currentProfile -Encoding UTF8
    Write-Host "  ✔ Đã cập nhật cấu hình HuyNex trong PowerShell Profile" -ForegroundColor Green
} else {
    Add-Content -Path $profilePath -Value "`n$profileBlock" -Encoding UTF8
    Write-Host "  ✔ Đã thêm cấu hình HuyNex vào PowerShell Profile" -ForegroundColor Green
}

# 5. Cài đặt Antigravity Skill
Write-Host "`n[5/5] Cài đặt Antigravity Skill (poweruser-workstation)..." -ForegroundColor Yellow
$skillDir = "$HOME\.gemini\config\skills\poweruser-workstation"
if (!(Test-Path $skillDir)) { New-Item -ItemType Directory -Path $skillDir -Force | Out-Null }
$skillUrl = "https://raw.githubusercontent.com/huylinhhg/huynex-poweruser/main/skill/SKILL.md"
Invoke-WebRequest -Uri $skillUrl -OutFile "$skillDir\SKILL.md"
Write-Host "  ✔ Đã cài đặt skill vào $skillDir\SKILL.md" -ForegroundColor Green

# ==============================================================================
# BÁO CÁO KẾT QUẢ HOÀN TẤT
# ==============================================================================
Write-Host "`n=================================================================" -ForegroundColor Cyan
Write-Host "   ✨ NÂNG CẤP HOÀN TẤT - BẠN ĐÃ LÀ TOP 1% POWER-USER! ✨" -ForegroundColor Green
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host "Các cải tiến đã được kích hoạt trên máy của bạn:" -ForegroundColor Yellow
Write-Host "  1. Zero-Latency Bàn phím: Tốc độ lướt phím và xóa chữ nhanh gấp 6 lần." -ForegroundColor White
Write-Host "  2. Kỷ nguyên CLI Rust: Dùng 'z' (nhảy thư mục), 'ls' (eza màu sắc/icon), 'cat' (bat highlight code), 'grep' (ripgrep siêu tốc)." -ForegroundColor White
Write-Host "  3. Bảo trì 1-Click: Gõ lệnh 'clean' hoặc 'huynex-clean' để dọn sạch máy trong 3s." -ForegroundColor White
Write-Host "  4. Antigravity AI Skill: Trong chat Antigravity, chỉ cần gõ 'Tối ưu máy' là AI tự làm mọi việc." -ForegroundColor White
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host "👉 Khởi động lại PowerShell để trải nghiệm ngay các công cụ mới!`n" -ForegroundColor Yellow
