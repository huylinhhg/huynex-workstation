# ⚡ HuyNex Zero-Latency Power-User Workstation ⚡

Bien bat ky may tinh **macOS** hoac **Windows** nao thanh co may phan xa tuc thi, sieu nhe va tinh gon cua **Top 1% Ky su cong nghe / Tech-Lead hang dau the gioi**. Tich hop san ky nang AI cho Antigravity.

**100% Mien phi • Khong loi font • Tat sach tac vu ngam • Do RAM thong minh • Zero-Bloat**

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

May se tu dong ket noi GitHub keo ban cai dat va toi uu moi nhat ve chay, hoan tat trong 30 giay va tu dong don dep thu muc cai dat sach se sau khi xong!

---

## ✨ CO CHE HOAT DONG THONG MINH (DO RAM & BAO QUAT HE THONG)

1. **Tu dong do RAM va phan tich Top ung dung chiem RAM:**
   - Kiem tra tong RAM, RAM dang su dung, RAM con trong.
   - Liet ke Top 5 tien trinh/ung dung dang chiem dung RAM cao nhat tren may.
2. **Triet tieu tac vu & dich vu chay ngam (Zero-Bloat):**
   - **Mac:** Diet Adobe CCLibrary, IPCBroker, CoreSync, CleanMyMac Monitors, Google & Coccoc Updaters, go bo LaunchAgents.
   - **Windows:** Vo hieu hoa vinh vien Google Update, Edge Update, AdobeARMservice, Telemetry (DiagTrack), MapsBroker, tat Tasks lich khoi dong ngam.
3. **Tu thich ung voi ca "May trang" (may moi mua) lan "May day ung dung":**
   - May moi chua co app rac: Bao cao he thong sach se, tu dong cai Homebrew / winget va toolchain Rust.
   - May cu co nhieu app: Tu dong don sach dich vu ngam, liet ke app ngam de giai phong tai nguyen.
4. **100% Chuan ASCII - Khong bao gio bi loi font tieng Viet:**
   - Toan bo thong bao trong Terminal / PowerShell su dung tieng Viet khong dau chuan ASCII, dam bao khong bi bien thanh ky tu la `???` hay loi ma hoa CodePage tren bat ky may Windows nao.

---

## 🛠 HUONG DAN SU DUNG BO CONG CU MOI

### 1. Nhay thu muc sieu toc voi `z` (thay vi `cd`)
```bash
z my-project    # Nhay ngay den thu muc my-project
z docs          # Nhay ngay den thu muc documents
```

### 2. Liet ke file tuyet dep voi `ls` & `ll` (`eza`)
```bash
ls              # Xem file kem icon va mau sac
ll              # Xem quyen han, kich thuoc va trang thai Git
lt              # Xem cay thu muc truc quan (tree view)
```

### 3. Doc file co highlight cu phap voi `cat` (`bat`)
```bash
cat index.js    # Xem code co so dong, highlight mau sac va bang ke
```

### 4. Tim kiem file sieu toc voi `fzf` & `grep` (`ripgrep`)
```bash
grep "my_func"  # Tim kiem trong toan bo ma nguon nhanh gap 10-50 lan
```

### 5. Don dep may sieu toc voi 1 lenh
```bash
clean           # Hoac go: huynex-clean
```

---

## 🤖 TICH HOP ANTIGRAVITY AI

Kich ban tu dong cai dat ky nang `poweruser-workstation` vao may cua ban. Moi khi ban mo Antigravity len, ban chi can go:
> *"Toi uu may cho tao"* hoac *"Kiem tra xem may co rac khong"*

AI se tu dong kiem tra RAM, diet tac vu ngam, don dep bo nho dem va duy tri may cua ban luon o trang thai dinh cao nhat!

---

## 📄 License
Phat hanh theo giay phep **MIT License**. Tu do su dung, chinh sua va chia se cho cong dong.
