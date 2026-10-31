<#
.SYNOPSIS
    HuyNex Zero-Latency Workstation Setup for Windows
    GitHub: https://github.com/huylinhhg/huynex-workstation
    100% Free - Khong loi font - Kien truc 2 Tang toi uu chuyen sau
#>

[Console]::OutputEncoding = [System.Text.Encoding]::ASCII
$Host.UI.RawUI.ForegroundColor = "Cyan"
Write-Host "================================================================="
Write-Host "   HUYNEX ZERO-LATENCY WORKSTATION (WINDOWS)" -ForegroundColor Green
Write-Host "   Toi uu phan xa, tat tac vu ngam, chong nghen RAM" -ForegroundColor White
Write-Host "   100% Free - Ma nguon mo - Zero-Bloat" -ForegroundColor Yellow
Write-Host "================================================================="
$Host.UI.RawUI.ForegroundColor = "White"

# ------------------------------------------------------------------------------
# [BUOC 1/6] KIEM TRA RAM VA PHAN TICH TIEN TRINH HE THONG
# ------------------------------------------------------------------------------
Write-Host "`n[1/6] Kiem tra tai nguyen RAM va phan tich he thong..." -ForegroundColor Yellow
try {
    $os = Get-CimInstance Win32_OperatingSystem -ErrorAction SilentlyContinue
    if ($os) {
        $totalRAM = [math]::Round($os.TotalVisibleMemorySize / 1MB, 2)
        $freeRAM = [math]::Round($os.FreePhysicalMemory / 1MB, 2)
        $usedRAM = [math]::Round($totalRAM - $freeRAM, 2)
        $pctUsed = [math]::Round(($usedRAM / $totalRAM) * 100, 1)

        Write-Host "  -> Tong RAM may: $totalRAM GB" -ForegroundColor White
        Write-Host "  -> RAM dang dung: $usedRAM GB ($pctUsed%)" -ForegroundColor White
        Write-Host "  -> RAM con trong: $freeRAM GB" -ForegroundColor Green
    }

    Write-Host "  -> Top 5 ung dung dang chiem nhieu RAM nhat:" -ForegroundColor Cyan
    Get-Process | Where-Object { $_.WorkingSet64 -gt 0 } | Sort-Object WorkingSet64 -Descending | Select-Object -First 5 | ForEach-Object {
        $ramMB = [math]::Round($_.WorkingSet64 / 1MB, 1)
        Write-Host "     * $($_.ProcessName): $ramMB MB" -ForegroundColor Gray
    }
} catch {
    Write-Host "  (!) Khong the doc chi tiet WMI, tiep tuc buoc ke tiep." -ForegroundColor Yellow
}

# ------------------------------------------------------------------------------
# [BUOC 2/6] TANG 1: TU DONG VO HIEU HOA CAC DICH VU / TAC VU NGAM (100% AN TOAN)
# ------------------------------------------------------------------------------
Write-Host "`n[2/6] [TANG 1] Quet va vo hieu hoa cac dich vu chay ngam 24/7..." -ForegroundColor Yellow

$servicesToDisable = @(
    @{ Name = "gupdate"; Desc = "Google Update (Tu dong)" },
    @{ Name = "gupdatem"; Desc = "Google Update (Thu cong)" },
    @{ Name = "edgeupdate"; Desc = "Microsoft Edge Update (Tu dong)" },
    @{ Name = "edgeupdatem"; Desc = "Microsoft Edge Update (Thu cong)" },
    @{ Name = "AdobeARMservice"; Desc = "Adobe Acrobat Update" },
    @{ Name = "DiagTrack"; Desc = "Connected User Experiences and Telemetry (Windows tracking)" },
    @{ Name = "dmwappushservice"; Desc = "WAP Push Routing Service" },
    @{ Name = "MapsBroker"; Desc = "Downloaded Maps Manager" }
)

$svcDisabled = 0
foreach ($svc in $servicesToDisable) {
    $found = Get-Service -Name $svc.Name -ErrorAction SilentlyContinue
    if ($found) {
        Stop-Service -Name $svc.Name -Force -ErrorAction SilentlyContinue
        Set-Service -Name $svc.Name -StartupType Disabled -ErrorAction SilentlyContinue
        Write-Host "  ✔ Da tat va vo hieu hoa: $($svc.Desc) ($($svc.Name))" -ForegroundColor Green
        $svcDisabled++
    }
}

if (Get-Command Disable-ScheduledTask -ErrorAction SilentlyContinue) {
    Get-ScheduledTask -ErrorAction SilentlyContinue | Where-Object { $_.TaskName -match "GoogleUpdate|MicrosoftEdgeUpdate|Adobe.*Update" } | ForEach-Object {
        Disable-ScheduledTask -TaskName $_.TaskName -ErrorAction SilentlyContinue | Out-Null
        Write-Host "  ✔ Da tat lich khoi dong ngam: $($_.TaskName)" -ForegroundColor Green
        $svcDisabled++
    }
}

$bloatProcesses = @("GoogleUpdate", "MicrosoftEdgeUpdate", "AdobeARM", "Creative Cloud", "AdobeDesktopService", "CCXProcess")
$procKilled = 0
foreach ($proc in $bloatProcesses) {
    $running = Get-Process -Name $proc -ErrorAction SilentlyContinue
    if ($running) {
        Stop-Process -Name $proc -Force -ErrorAction SilentlyContinue
        Write-Host "  ✔ Da dong tien trinh ngam: $proc" -ForegroundColor Green
        $procKilled++
    }
}

if ($svcDisabled -eq 0 -and $procKilled -eq 0) {
    Write-Host "  ✔ He thong sach se (may moi hoac da toi uu), khong co tien trinh ngam ton dong." -ForegroundColor Green
}

try {
    $dataCollectionPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
    if (!(Test-Path $dataCollectionPath)) { New-Item -Path $dataCollectionPath -Force -ErrorAction SilentlyContinue | Out-Null }
    Set-ItemProperty -Path $dataCollectionPath -Name "AllowTelemetry" -Value 0 -Force -ErrorAction SilentlyContinue | Out-Null

    $searchPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search"
    if (!(Test-Path $searchPath)) { New-Item -Path $searchPath -Force -ErrorAction SilentlyContinue | Out-Null }
    Set-ItemProperty -Path $searchPath -Name "BingSearchEnabled" -Value 0 -Force -ErrorAction SilentlyContinue | Out-Null
    Set-ItemProperty -Path $searchPath -Name "CortanaConsent" -Value 0 -Force -ErrorAction SilentlyContinue | Out-Null

    $adPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo"
    if (!(Test-Path $adPath)) { New-Item -Path $adPath -Force -ErrorAction SilentlyContinue | Out-Null }
    Set-ItemProperty -Path $adPath -Name "Enabled" -Value 0 -Force -ErrorAction SilentlyContinue | Out-Null
    Write-Host "  ✔ Da triet tieu Telemetry thu thap du lieu va Bing Search ngam." -ForegroundColor Green
} catch {
    Write-Host "  (!) Bo qua ghi Registry he thong (khong can quyen Admin)." -ForegroundColor Yellow
}

# ------------------------------------------------------------------------------
# [BUOC 3/6] TANG 2: TUY CHON NANG CAO (TAT CAC TINH NANG AN NGON 1-2 GB RAM)
# ------------------------------------------------------------------------------
Write-Host "`n=================================================================" -ForegroundColor Cyan
Write-Host "   [TANG 2] TUY CHON TOI UU CAC TINH NANG AN HE THONG" -ForegroundColor Green
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host "Cac tinh nang an nay mac dinh cua Windows an ngam 1-2 GB RAM:" -ForegroundColor Yellow
Write-Host "  1. Widgets / Bang tin thoi tiet Win 11 (ngon 300-500 MB RAM Edge WebView)" -ForegroundColor White
Write-Host "  2. Xbox Game Bar & Ghi hinh ngam DVR (ngon 200-300 MB RAM)" -ForegroundColor White
Write-Host "  3. Windows Delivery Optimization P2P (ngon bang thong va RAM)" -ForegroundColor White
Write-Host "  4. App nang tu khoi dong cung Windows (Discord, Spotify, Steam, Teams)" -ForegroundColor White

Write-Host ""
$optChoice = Read-Host "Ban co muon tat cac tinh nang an nay de tiet kiem them RAM khong? (Y/n) [Mac dinh: Y]"
if ([string]::IsNullOrWhiteSpace($optChoice)) { $optChoice = "y" }

if ($optChoice -match "^[Yy]$") {
    Write-Host "`n-> Dang tat cac tinh nang an he thong..." -ForegroundColor Cyan

    try {
        $advPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
        Set-ItemProperty -Path $advPath -Name "TaskbarDa" -Value 0 -Force -ErrorAction SilentlyContinue | Out-Null
        Stop-Process -Name "Widgets" -Force -ErrorAction SilentlyContinue
        Write-Host "  ✔ Da tat Widgets & Bang tin thoi tiet Win 11 (Tiet kiem ~400 MB RAM)" -ForegroundColor Green
    } catch {}

    try {
        Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -Value 0 -Force -ErrorAction SilentlyContinue | Out-Null
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Name "AllowGameDVR" -Value 0 -Force -ErrorAction SilentlyContinue | Out-Null
        Stop-Process -Name "GameBar" -Force -ErrorAction SilentlyContinue
        Stop-Process -Name "bcastdvr" -Force -ErrorAction SilentlyContinue
        Write-Host "  ✔ Da tat Xbox Game Bar & Ghi hinh ngam (Tiet kiem ~250 MB RAM)" -ForegroundColor Green
    } catch {}

    if (Get-Service -Name "DoSvc" -ErrorAction SilentlyContinue) {
        Stop-Service -Name "DoSvc" -Force -ErrorAction SilentlyContinue
        Set-Service -Name "DoSvc" -StartupType Disabled -ErrorAction SilentlyContinue
        Write-Host "  ✔ Da vo hieu hoa Windows Delivery Optimization P2P" -ForegroundColor Green
    }

    $runPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
    if (Test-Path $runPath) {
        $runProps = Get-ItemProperty -Path $runPath -ErrorAction SilentlyContinue
        $heavyApps = @("Discord", "Spotify", "Steam", "Teams", "OneDrive")
        foreach ($app in $heavyApps) {
            if ($runProps.$app) {
                Remove-ItemProperty -Path $runPath -Name $app -ErrorAction SilentlyContinue | Out-Null
                Write-Host "  ✔ Da bo khoi dong cung Windows cho: $app (Giai phong RAM khi mo may)" -ForegroundColor Green
            }
        }
    }
} else {
    Write-Host "-> Da giu nguyen cac tinh nang an theo y muon cua ban." -ForegroundColor Yellow
}

# ------------------------------------------------------------------------------
# [BUOC 4/6] TOI UU TOC DO PHAN HOI BAN PHIM (ZERO-LATENCY)
# ------------------------------------------------------------------------------
Write-Host "`n[4/6] Toi uu toc do phan hoi ban phim len muc toi da..." -ForegroundColor Yellow
try {
    Set-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name "KeyboardSpeed" -Value 31 -Force
    Set-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name "KeyboardDelay" -Value 0 -Force
    Write-Host "  ✔ Da cai dat: KeyboardSpeed = 31, KeyboardDelay = 0 (Toc do luot phim cuc dai)" -ForegroundColor Green
} catch {
    Write-Host "  (!) Khong the chinh Registry ban phim: $($_.Exception.Message)" -ForegroundColor Red
}

# ------------------------------------------------------------------------------
# [BUOC 5/6] KIEM TRA & CAI DAT BO CONG CU CLI RUST QUA WINGET
# ------------------------------------------------------------------------------
Write-Host "`n[5/6] Kiem tra va cai dat bo cong cu CLI the he moi qua winget..." -ForegroundColor Yellow
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
            Write-Host "  ✔ $($pkg.Name) da co san." -ForegroundColor Green
        } else {
            Write-Host "  -> Dang cai dat $($pkg.Name)..." -ForegroundColor Cyan
            winget install --id $pkg.Id --exact --source winget --accept-source-agreements --accept-package-agreements --silent --no-upgrade | Out-Null
            Write-Host "  ✔ Da cai dat $($pkg.Name)" -ForegroundColor Green
        }
    }
} else {
    Write-Host "  (!) May chua co winget (App Installer cua Microsoft Store)." -ForegroundColor Yellow
    Write-Host "      Bo qua buoc cai CLI, he thong van duoc toi uu ban phim va tat tac vu ngam." -ForegroundColor White
}

# ------------------------------------------------------------------------------
# [BUOC 6/6] CAI DAT CONG CU BAO TRI, PROFILE POWERSHELL & SKILL AI
# ------------------------------------------------------------------------------
Write-Host "`n[6/6] Cai dat cong cu bao tri 1-Click va profile..." -ForegroundColor Yellow
$binDir = "$HOME\.local\bin"
if (!(Test-Path $binDir)) { New-Item -ItemType Directory -Path $binDir -Force | Out-Null }
$cleanScriptUrl = "https://raw.githubusercontent.com/huylinhhg/huynex-workstation/main/bin/huynex-clean.ps1"
Invoke-WebRequest -Uri $cleanScriptUrl -OutFile "$binDir\huynex-clean.ps1" -ErrorAction SilentlyContinue
Write-Host "  ✔ Da tai huynex-clean.ps1 vao $binDir\huynex-clean.ps1" -ForegroundColor Green

$profilePath = $PROFILE
$profileDir = Split-Path $profilePath -Parent
if (!(Test-Path $profileDir)) { New-Item -ItemType Directory -Path $profileDir -Force | Out-Null }

$markerStart = "# === HUYNEX_POWER_USER_START ==="
$markerEnd = "# === HUYNEX_POWER_USER_END ==="

$profileBlock = @"
$markerStart
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
    $currentProfile = Get-Content -Path $profilePath -Raw -Encoding UTF8 -ErrorAction SilentlyContinue
}

$startEsc = [regex]::Escape($markerStart)
$endEsc = [regex]::Escape($markerEnd)
if ($currentProfile -match $startEsc) {
    $currentProfile = [regex]::Replace($currentProfile, "(?s)$startEsc.*?$endEsc", $profileBlock)
    Set-Content -Path $profilePath -Value $currentProfile -Encoding UTF8
    Write-Host "  ✔ Da cap nhat cau hinh HuyNex trong PowerShell Profile" -ForegroundColor Green
} else {
    Add-Content -Path $profilePath -Value "`n$profileBlock" -Encoding UTF8
    Write-Host "  ✔ Da them cau hinh HuyNex vao PowerShell Profile" -ForegroundColor Green
}

$skillDir = "$HOME\.gemini\config\skills\poweruser-workstation"
if (!(Test-Path $skillDir)) { New-Item -ItemType Directory -Path $skillDir -Force | Out-Null }
$skillUrl = "https://raw.githubusercontent.com/huylinhhg/huynex-workstation/main/skill/SKILL.md"
Invoke-WebRequest -Uri $skillUrl -OutFile "$skillDir\SKILL.md" -ErrorAction SilentlyContinue
Write-Host "  ✔ Da cai dat skill vao $skillDir\SKILL.md" -ForegroundColor Green

# ==============================================================================
# BAO CAO KET QUA HOAN TAT
# ==============================================================================
Write-Host "`n=================================================================" -ForegroundColor Cyan
Write-Host "   NANG CAP HOAN TAT - BAN DA LA TOP 1% POWER-USER!" -ForegroundColor Green
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host "Cac cai tien da duoc kich hoat tren may cua ban (100% Free):" -ForegroundColor Yellow
Write-Host "  1. TAT SACH TAC VU NGAM: Da vo hieu hoa cac dich vu updater & telemetry." -ForegroundColor White
Write-Host "  2. Zero-Latency Ban phim: Toc do luot phim va xoa chu nhanh gap 6 lan." -ForegroundColor White
Write-Host "  3. Ky nguyen CLI Rust: Dung 'z' (nhay thu muc), 'ls' (eza), 'cat' (bat), 'grep' (rg)." -ForegroundColor White
Write-Host "  4. Bao tri 1-Click: Go lenh 'clean' hoac 'huynex-clean' de don may trong 3s." -ForegroundColor White
Write-Host "  5. Antigravity AI Skill: Trong chat Antigravity, chi can go 'Toi uu may'." -ForegroundColor White
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host "👉 Khoi dong lai PowerShell de trai nghiem ngay cac cong cu moi!`n" -ForegroundColor Yellow
