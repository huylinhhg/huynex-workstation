# ⚡ HuyNex Zero-Latency Power-User Workstation ⚡

Biến bất kỳ máy tính **macOS** hoặc **Windows** nào thành cỗ máy phản xạ tức thì, siêu nhẹ và tinh gọn của **Top 1% Kỹ sư công nghệ / Tech-Lead hàng đầu thế giới**. Tích hợp sẵn kỹ năng AI cho Antigravity.

**100% Miễn phí • Tắt sạch tác vụ ngầm • Không trả phí • Không thuê bao • Zero-Bloat**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-macOS%20%7C%20Windows-green.svg)](README.md)
[![Antigravity](https://img.shields.io/badge/Antigravity-Skill%20Ready-purple.svg)](skill/SKILL.md)

---

## 🚀 CÀI ĐẶT 1 DÒNG DUY NHẤT (QUICK INSTALL)

### 🍎 Dành cho macOS
Mở Terminal và dán đúng 1 dòng lệnh sau:
```bash
curl -fsSL https://raw.githubusercontent.com/huylinhhg/huynex-workstation/main/setup-mac.sh | bash
```

### 🪟 Dành cho Windows
Mở PowerShell (Run as Administrator hoặc Standard) và dán đúng 1 dòng lệnh sau:
```powershell
irm https://raw.githubusercontent.com/huylinhhg/huynex-workstation/main/setup-windows.ps1 | iex
```

---

## 📦 HOẶC GỬI FILE ZIP CẦU NỐI 1-CLICK (GỬI QUA ZALO)

Bạn chỉ cần gửi file zip siêu nhẹ (`~4 KB`) cho bạn bè. Người nhận chỉ việc giải nén ra màn hình:
- **Nếu dùng máy Mac:** Bấm đúp vào file `🍎 Cai-dat-Mac.command`
- **Nếu dùng máy Windows:** Bấm đúp vào file `🪟 Cai-dat-Windows.cmd`

Máy sẽ tự động kết nối GitHub kéo bản cài đặt và tối ưu mới nhất về chạy, hoàn tất trong 30 giây và tự động dọn dẹp thư mục cài đặt sạch sẽ sau khi xong!

---

## ✨ CÁC TÍNH NĂNG ĐƯỢC KÍCH HOẠT TỰ ĐỘNG

| Hạng mục | Trước khi cài | Sau khi cài (HuyNex Standard) | Lợi ích thực tế |
| :--- | :--- | :--- | :--- |
| **Tác vụ chạy ngầm** | Hàng chục daemon ngầm (Adobe, CleanMyMac, Updaters, Telemetry) ăn ngầm 2-4 GB RAM | **TẮT SẠCH TẬN GỐC (Zero-Bloat)**: Diệt tiến trình & vô hiệu hóa tự khởi động 24/7 | Máy mát mẻ, CPU 0%, giải phóng hàng GB RAM thực |
| **Tốc độ lướt phím** | Chậm mặc định (Apple / Win) | **Siêu tốc** (`KeyRepeat = 2`, `Delay = 0`) | Lướt con trỏ, xóa chữ nhanh gấp 6 lần |
| **Độ trễ màn hình** | Trễ hoạt ảnh Dock / Cửa sổ | **Zero-Latency** (0s delay, tắt animation thừa) | Mở cửa sổ, ẩn hiện Dock ngay lập tức |
| **Dòng lệnh CLI** | `ls`, `cat`, `cd`, `grep` cổ điển | **Kỷ nguyên Rust:** `z`, `eza`, `bat`, `ripgrep`, `fzf` | Nhảy thư mục tức thì, code highlight màu sắc |
| **Bảo trì 1-Click** | Mở app dọn rác nặng nề | Lệnh `clean` / `huynex-clean` | Dọn sạch rác, cache dev và tác vụ ngầm trong 3 giây |
| **Antigravity AI** | Chưa có hướng dẫn chuẩn | Skill `poweruser-workstation` tích hợp sẵn | Trong chat AI: gõ *"Tối ưu máy"* là AI tự làm |

---

## 🛡️ CHI TIẾT TẮT TÁC VỤ CHẠY NGẦM

### Trên macOS:
1. **Diệt sạch tiến trình ngầm ăn RAM:** Adobe CCLibrary (`node`), Adobe IPCBroker, CoreSync, CleanMyMac HealthMonitor/Menu, Google Software Update Agent, Cốc Cốc Updater, Microsoft AU Daemon.
2. **Vô hiệu hóa LaunchAgents:** Xóa bỏ các tập tin `.plist` tự khởi động ngầm trong `~/Library/LaunchAgents`.
3. **Tắt CrashReporter Dialogs & App Resume:** Ngăn ngừa việc khôi phục các cửa sổ lỗi gây đơ máy khi khởi động lại.

### Trên Windows:
1. **Vô hiệu hóa vĩnh viễn Services ngầm:** Google Update (`gupdate`, `gupdatem`), Edge Update (`edgeupdate`, `edgeupdatem`), Adobe Acrobat Update (`AdobeARMservice`), Windows Telemetry (`DiagTrack`), WAP Push (`dmwappushservice`).
2. **Đóng tiến trình ngầm:** `GoogleUpdate.exe`, `MicrosoftEdgeUpdate.exe`, `AdobeARM.exe`.
3. **Triệt tiêu Telemetry & Bloat tìm kiếm:** Tắt thu thập dữ liệu trong Registry, tắt Bing Search và Cortana chạy ngầm trong Start Menu.

---

## 🛠 HƯỚNG DẪN SỬ DỤNG BỘ CÔNG CỤ MỚI

### 1. Nhảy thư mục siêu tốc với `z` (thay vì `cd`)
```bash
z my-project    # Nhảy ngay đến thư mục my-project
z docs          # Nhảy ngay đến thư mục documents
```

### 2. Liệt kê file tuyệt đẹp với `ls` & `ll` (`eza`)
```bash
ls              # Xem file kèm icon và màu sắc
ll              # Xem quyền hạn, kích thước và trạng thái Git
lt              # Xem cây thư mục trực quan (tree view)
```

### 3. Đọc file có highlight cú pháp với `cat` (`bat`)
```bash
cat index.js    # Xem code có số dòng, highlight màu sắc và bảng kẻ
```

### 4. Tìm kiếm file siêu tốc với `fzf` & `grep` (`ripgrep`)
```bash
grep "my_func"  # Tìm kiếm trong toàn bộ mã nguồn nhanh gấp 10-50 lần
```

### 5. Dọn dẹp máy siêu tốc với 1 lệnh
```bash
clean           # Hoặc gõ: huynex-clean
```

---

## 🤖 TÍCH HỢP ANTIGRAVITY AI

Kịch bản tự động cài đặt kỹ năng `poweruser-workstation` vào máy của bạn. Mỗi khi bạn mở Antigravity lên, bạn chỉ cần gõ:
> *"Tối ưu máy cho tao"* hoặc *"Kiểm tra xem máy có rác không"*

AI sẽ tự động kiểm tra RAM, diệt tác vụ ngầm, dọn dẹp bộ nhớ đệm và duy trì máy của bạn luôn ở trạng thái đỉnh cao nhất!

---

## 📄 License
Phát hành theo giấy phép **MIT License**. Tự do sử dụng, chỉnh sửa và chia sẻ cho cộng đồng.
