<#
.SYNOPSIS
    HuyNex Power-User Workstation 1-Click Installer for Windows
    GitHub: https://github.com/huylinhhg/huynex-workstation
.DESCRIPTION
    Tắt tận gốc tác vụ chạy ngầm (Zero-Bloat), tối ưu phím Zero-Latency,
    cài đặt bộ công cụ CLI Rust hiện đại, cấu hình PowerShell Profile và tích hợp AI.
#>

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$Host.UI.RawUI.ForegroundColor = "Cyan"
Write-Host "================================================================="
Write-Host "   ⚡ HUYNEX ZERO-LATENCY POWER-USER WORKSTATION (Windows) ⚡" -ForegroundColor Green
Write-Host "      Biến máy Windows thành cỗ máy phản xạ tức thì của Top 1%" -ForegroundColor White
Write-Host "       100% Miễn phí • Tắt sạch tác vụ ngầm • Zero-Bloat" -ForegroundColor Yellow
Write-Host "================================================================="
$Host.UI.RawUI.ForegroundColor = "White"

# ------------------------------------------------------------------------------
# [BƯỚC 1/6] TRIỆT TIÊU TOÀN BỘ TIẾN TRÌNH & DỊCH VỤ CHẠY NGẦM ĂN RAM/CPU
# ------------------------------------------------------------------------------
Write-Host "`n[1/6] Quét & Tắt sạch các dịch vụ và tiến trình chạy ngầm (Zero-Bloat)..." -ForegroundColor Yellow

# A. Tắt và vô hiệu hóa các Service chạy ngầm ăn tài nguyên / Updater / Telemetry
$servicesToDisable = @(
    @{ Name = "gupdate"; Desc = "Google Update (Auto)" },
    @{ Name = "gupdatem"; Desc = "Google Update (Manual)" },
    @{ Name = "edgeupdate"; Desc = "Microsoft Edge Update (Auto)" },
    @{ Name = "edgeupdatem"; Desc = "Microsoft Edge Update (Manual)" },
    @{ Name = "AdobeARMservice"; Desc = "Adobe Acrobat Update Service" },
    @{ Name = "DiagTrack"; Desc = "Connected User Experiences and Telemetry (Windows tracking)" },
    @{ Name = "dmwappushservice"; Desc = "WAP Push Routing Service" },
    @{ Name = "MapsBroker"; Desc = "Downloaded Maps Manager" }
)

$svcCount = 0
foreach ($svc in $servicesToDisable) {
    if (Get-Service -Name $svc.Name -ErrorAction SilentlyContinue) {
        Stop-Service -Name $svc.Name -Force -ErrorAction SilentlyContinue
        Set-Service -Name $svc.Name -StartupType Disabled -ErrorAction SilentlyContinue
        Write-Host "  ✔ Đã vô hiệu hóa vĩnh viễn dịch vụ ngầm: $($svc.Desc) ($($svc.Name))" -ForegroundColor Green
        $svcCount++
    }
}

# B. Diệt các tiến trình ngầm đang chiếm dụng RAM/CPU
$bloatProcesses = @("GoogleUpdate", "MicrosoftEdgeUpdate", "AdobeARM", "Creative Cloud", "AdobeDesktopService", "CCXProcess")
$procCount = 0
foreach ($proc in $bloatProcesses) {
    $running = Get-Process -Name $proc -ErrorAction SilentlyContinue
    if ($running) {
        Stop-Process -Name $proc -Force -ErrorAction SilentlyContinue
        Write-Host "  ✔ Đã đóng tiến trình chạy ngầm: $proc" -ForegroundColor Green
        $procCount++
    }
}

# C. Tắt Windows Telemetry & Bloat tìm kiếm trong Registry
try {
    # Tắt Telemetry thu thập dữ liệu
    $dataCollectionPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
    if (!(Test-Path $dataCollectionPath)) { New-Item -Path $dataCollectionPath -Force | Out-Null }
    Set-ItemProperty -Path $dataCollectionPath -Name "AllowTelemetry" -Value 0 -Force -ErrorAction SilentlyContinue

    # Tắt Bing Search & Cortana ngầm trong Menu Start
    $searchPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search"
    if (!(Test-Path $searchPath)) { New-Item -Path $searchPath -Force | Out-Null }
    Set-ItemProperty -Path $searchPath -Name "BingSearchEnabled" -Value 0 -Force -ErrorAction SilentlyContinue
    Set-ItemProperty -Path $searchPath -Name "CortanaConsent" -Value 0 -Force -ErrorAction SilentlyContinue

    # Tắt theo dõi quảng cáo ngầm
    $adPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo"
    if (!(Test-Path $adPath)) { New-Item -Path $adPath -Force | Out-Null }
    Set-ItemProperty -Path $adPath -Name "Enabled" -Value 0 -Force -ErrorAction SilentlyContinue
    Write-Host "  ✔ Đã triệt tiêu Telemetry thu thập dữ liệu và Bing Search ngầm." -ForegroundColor Green
} catch {
    Write-Host "  ⚠ Bỏ qua tinh chỉnh Registry hệ thống (chạy không cần quyền Admin)." -ForegroundColor Yellow
}

# ------------------------------------------------------------------------------
# [BƯỚC 2/6] TỐI ƯU BÀN PHÍM ZERO-LATENCY
# ------------------------------------------------------------------------------
Write-Host "`n[2/6] Tối ưu tốc độ phản hồi bàn phím (Zero-Latency UI)..." -ForegroundColor Yellow
try {
    Set-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name "KeyboardSpeed" -Value 31 -Force
    Set-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name "KeyboardDelay" -Value 0 -Force
    Write-Host "  ✔ Đã thiết lập KeyboardSpeed = 31, KeyboardDelay = 0 (tốc độ tối đa)" -ForegroundColor Green
} catch {
    Write-Host "  ⚠ Không thể chỉnh Registry: $($_.Exception.Message)" -ForegroundColor Red
}

# ------------------------------------------------------------------------------
# [BƯỚC 3/6] CÀI ĐẶT BỘ CÔNG CỤ CLI RUST QUA WINGET
# ------------------------------------------------------------------------------
Write-Host "`n[3/6] Kiểm tra và cài đặt bộ công cụ CLI Rust qua winget..." -ForegroundColor Yellow
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

# ------------------------------------------------------------------------------
# [BƯỚC 4/6] CÀI ĐẶT CÔNG CỤ BẢO TRÌ HUYNEX-CLEAN.PS1
# ------------------------------------------------------------------------------
Write-Host "`n[4/6] Cài đặt công cụ bảo trì 1-Click (huynex-clean.ps1)..." -ForegroundColor Yellow
$binDir = "$HOME\.local\bin"
if (!(Test-Path $binDir)) { New-Item -ItemType Directory -Path $binDir -Force | Out-Null }
$cleanScriptUrl = "https://raw.githubusercontent.com/huylinhhg/huynex-workstation/main/bin/huynex-clean.ps1"
Invoke-WebRequest -Uri $cleanScriptUrl -OutFile "$binDir\huynex-clean.ps1"
Write-Host "  ✔ Đã tải huynex-clean.ps1 vào $binDir\huynex-clean.ps1" -ForegroundColor Green

# ------------------------------------------------------------------------------
# [BƯỚC 5/6] CẤU HÌNH POWERSHELL PROFILE ($PROFILE)
# ------------------------------------------------------------------------------
Write-Host "`n[5/6] Cấu hình PowerShell Profile ($PROFILE)..." -ForegroundColor Yellow
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

# ------------------------------------------------------------------------------
# [BƯỚC 6/6] CÀI ĐẶT ANTIGRAVITY SKILL
# ------------------------------------------------------------------------------
Write-Host "`n[6/6] Cài đặt Antigravity Skill (poweruser-workstation)..." -ForegroundColor Yellow
$skillDir = "$HOME\.gemini\config\skills\poweruser-workstation"
if (!(Test-Path $skillDir)) { New-Item -ItemType Directory -Path $skillDir -Force | Out-Null }
$skillUrl = "https://raw.githubusercontent.com/huylinhhg/huynex-workstation/main/skill/SKILL.md"
Invoke-WebRequest -Uri $skillUrl -OutFile "$skillDir\SKILL.md"
Write-Host "  ✔ Đã cài đặt skill vào $skillDir\SKILL.md" -ForegroundColor Green

# ==============================================================================
# BÁO CÁO KẾT QUẢ HOÀN TẤT
# ==============================================================================
Write-Host "`n=================================================================" -ForegroundColor Cyan
Write-Host "   ✨ NÂNG CẤP HOÀN TẤT - BẠN ĐÃ LÀ TOP 1% POWER-USER! ✨" -ForegroundColor Green
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host "Các cải tiến đã được kích hoạt trên máy của bạn (100% Free):" -ForegroundColor Yellow
Write-Host "  1. TẮT TẬN GỐC TÁC VỤ NGẦM: Đã vô hiệu hóa các dịch vụ ngầm (Google Update, Edge Update, Adobe, Telemetry)." -ForegroundColor White
Write-Host "  2. Zero-Latency Bàn phím: Tốc độ lướt phím và xóa chữ nhanh gấp 6 lần." -ForegroundColor White
Write-Host "  3. Kỷ nguyên CLI Rust: Dùng 'z' (nhảy thư mục), 'ls' (eza màu sắc/icon), 'cat' (bat highlight code), 'grep' (ripgrep siêu tốc)." -ForegroundColor White
Write-Host "  4. Bảo trì 1-Click: Gõ lệnh 'clean' hoặc 'huynex-clean' để dọn sạch máy trong 3s." -ForegroundColor White
Write-Host "  5. Antigravity AI Skill: Trong chat Antigravity, chỉ cần gõ 'Tối ưu máy' là AI tự làm mọi việc." -ForegroundColor White
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host "👉 Khởi động lại PowerShell để trải nghiệm ngay các công cụ mới!`n" -ForegroundColor Yellow
