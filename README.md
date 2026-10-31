# ⚡ HuyNex Zero-Latency Power-User Workstation ⚡

Bien bat ky may tinh **macOS** hoac **Windows** nao thanh co may phan xa tuc thi, sieu nhe va tinh gon cua **Top 1% Ky su cong nghe / Tech-Lead hang dau the gioi**. Tich hop san ky nang AI cho Antigravity.

**100% Mien phi • Khong loi font • Kien truc 2 Tang toi uu • Do RAM thong minh • Zero-Bloat**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-macOS%20%7C%20Windows-green.svg)](README.md)
[![Antigravity](https://img.shields.io/badge/Antigravity-Skill%20Ready-purple.svg)](skill/SKILL.md)

---

## 🚀 CAI DAT 1 DONG DUY NHAT (QUICK INSTALL)

### 🍎 Danh cho macOS
Mo Terminal va dan dung 1 dong lenh sau:
```bash
curl -fsSL https://raw.githubusercontent.com/huylinhhg/huynex-workstation/main/setup-mac.sh | bash
```

### 🪟 Danh cho Windows
Mo PowerShell (Run as Administrator hoac Standard) va dan dung 1 dong lenh sau:
```powershell
irm https://raw.githubusercontent.com/huylinhhg/huynex-workstation/main/setup-windows.ps1 | iex
```

---

## 📦 HOAC GUI FILE ZIP CAU NOI 1-CLICK (GUI QUA ZALO)

Ban chi can gui file zip sieu nhe (`~4 KB`) cho ban be. Nguoi nhan chi viec giai nen ra man hinh:
- **Neu dung may Mac:** Bam dup vao file `Cai-dat-Mac.command`
- **Neu dung may Windows:** Bam dup vao file `Cai-dat-Windows.cmd`

---

## 🏗️ KIEN TRUC 2 TANG TOI UU CHUYEN SAU (ZERO-BLOAT)

Kich ban duoc thiet ke theo mo hinh 2 Tang thong minh:

### 🛡️ TANG 1: TU DONG 100% (AN TOAN TUYET DOI)
- **Do RAM dong:** Hien thi tong dung luong RAM va Top 5 ung dung chiem RAM nhat.
- **Diet sach dich vu ngam 24/7:**
  - *Windows:* Google Update (`gupdate`), Edge Update (`edgeupdate`), Adobe Acrobat Update (`AdobeARMservice`), Telemetry theo doi Windows (`DiagTrack`), WAP Push, MapsBroker, cac lich Task Scheduler cap nhat ngam.
  - *Mac:* Adobe CCLibrary, IPCBroker, CoreSync, CleanMyMac Monitors, Google & Coccoc Updaters, LaunchAgents trong `~/Library/LaunchAgents`.
- **Toi uu ban phim Zero-Latency:** Day toc do phan hoi phim va xoa chu len cuc dai.
- **Trang bi CLI the he moi:** `zoxide` (nhay thu muc), `eza` (ls mau sac/icon), `bat` (cat highlight), `ripgrep` (grep sieu toc), `fzf`.
- **Tich hop AI:** Tu dong nap skill `poweruser-workstation` vao Antigravity.

### 🎛️ TANG 2: MENU TUY CHON NANG CAO (KHACH TU CHON Y/N)
He thong se hoi nguoi dung de tat cac tinh nang an mac dinh an rat nhieu tai nguyen:
- **Tren Windows:**
  1. *Widgets & Bang tin thoi tiet Win 11:* Tat 4-6 tien trinh `msedgewebview2.exe` chay ngam (tiet kiem ~400 MB RAM).
  2. *Xbox Game Bar & Background DVR:* Tat ghi hinh man hinh ngam `bcastdvr.exe` (tiet kiem ~250 MB RAM).
  3. *Windows Delivery Optimization:* Tat chia se ban cap nhat qua mang P2P (tiet kiem bang thong & RAM).
  4. *App nang tu khoi dong cung Windows:* Go bo khoi dong ngam cua Discord, Spotify, Steam, Teams.
- **Tren macOS:**
  1. *Time Machine Local Snapshots:* Xoa cac ban sao luu cuc bo an tren SSD (giai phong 10 - 40 GB SSD).
  2. *Google Chrome chay ngam:* Tat tinh nang Chrome van chay ngam sau khi dong cua so.
  3. *Kiem tra Login Items:* Liet ke danh sach ung dung tu dong mo khi khoi dong may.

---

## 🛠 HUONG DAN SU DUNG BO CONG CU MOI

```bash
z my-project    # Nhay ngay den thu muc my-project (thay the cd)
ls              # Xem file kem icon va mau sac (eza)
ll              # Xem quyen han, kich thuoc va trang thai Git
cat index.js    # Xem code co so dong va highlight cu phap (bat)
grep "my_func"  # Tim kiem trong toan bo ma nguon nhanh gap 10-50 lan (rg)
clean           # Don dep sach se cache, rac va tien trinh ngam trong 3 giay
```

---

## 🤖 TICH HOP ANTIGRAVITY AI

Kich ban tu dong cai dat ky nang `poweruser-workstation` vao may cua ban. Trong chat Antigravity, chi can go:
> *"Toi uu may cho tao"* hoac *"Kiem tra xem may co rac khong"*

---

## 📄 License
Phat hanh theo giay phep **MIT License**. Tu do su dung, chinh sua va chia se cho cong dong.
