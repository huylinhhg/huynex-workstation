# ⚡ HuyNex Zero-Latency Power-User Workstation ⚡

Biến bất kỳ máy tính **macOS** hoặc **Windows** nào thành cỗ máy phản xạ tức thì, siêu nhẹ và tinh gọn của **Top 1% Kỹ sư công nghệ / Tech-Lead hàng đầu thế giới**. Tích hợp sẵn kỹ năng AI cho Antigravity.

**100% Miễn phí • Mã nguồn mở • Không trả phí • Không thuê bao • Zero-Bloat**

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

Bạn chỉ cần gửi file zip siêu nhẹ (`~2 KB`) cho bạn bè. Người nhận chỉ việc giải nén ra màn hình:
- **Nếu dùng máy Mac:** Bấm đúp vào file `🍎 Cai-dat-Mac.command`
- **Nếu dùng máy Windows:** Bấm đúp vào file `🪟 Cai-dat-Windows.cmd`

Máy sẽ tự động kết nối GitHub kéo bản cài đặt và tối ưu mới nhất về chạy, hoàn tất trong 30 giây và tự động dọn dẹp thư mục cài đặt sạch sẽ sau khi xong!

---

## ✨ CÁC TÍNH NĂNG ĐƯỢC KÍCH HOẠT TỰ ĐỘNG

| Tính năng | Trước khi cài | Sau khi cài (HuyNex Standard) | Lợi ích |
| :--- | :--- | :--- | :--- |
| **Tốc độ lướt phím** | Chậm mặc định (Apple / Win) | **Siêu tốc** (`KeyRepeat = 2`, `Delay = 0`) | Lướt con trỏ, xóa chữ nhanh gấp 6 lần |
| **Độ trễ màn hình** | Trễ hoạt ảnh Dock / Cửa sổ | **Zero-Latency** (0s delay, tắt animation thừa) | Mở cửa sổ, ẩn hiện Dock ngay lập tức |
| **Dòng lệnh CLI** | `ls`, `cat`, `cd`, `grep` cổ điển | **Kỷ nguyên Rust:** `z`, `eza`, `bat`, `ripgrep`, `fzf` | Nhảy thư mục tức thì, code highlight màu sắc |
| **Bảo trì 1-Click** | Mở app dọn rác nặng nề | Lệnh `clean` / `huynex-clean` | Dọn sạch cache, temp, log cũ trong 3 giây |
| **Antigravity AI** | Chưa có hướng dẫn chuẩn | Skill `poweruser-workstation` tích hợp sẵn | Trong chat AI: gõ *"Tối ưu máy"* là AI tự làm |

---

## 🛡️ CAM KẾT BẢO MẬT & MINH BẠCH 100%

1. **Tuyệt đối không chạy ngầm (Zero-Daemon):** Không tạo daemon, không tạo service chạy ngầm 24/7, không hao tốn tài nguyên máy.
2. **Không thu thập dữ liệu (Zero-Telemetry):** Không gửi bất kỳ dữ liệu nào ra ngoài máy của bạn.
3. **Mã nguồn mở hoàn toàn:** Kịch bản cài đặt là văn bản thuần túy (`.sh`, `.ps1`), minh bạch 100%, ai cũng có thể đọc và kiểm tra trước khi chạy.
4. **100% Miễn phí vĩnh viễn:** Không đòi hỏi thẻ tín dụng, không dùng app bản quyền hay tính phí thuê bao.

---

## 🛠 HƯỚNG DẪN SỬ DỤNG BỘ CÔNG CỤ MỚI

### 1. Nhảy thư mục siêu tốc với `z` (thay vì `cd`)
Không cần gõ đường dẫn dài dòng:
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

AI sẽ tự động kiểm tra RAM, dọn dẹp bộ nhớ đệm và duy trì máy của bạn luôn ở trạng thái đỉnh cao nhất!

---

## 📄 License
Phát hành theo giấy phép **MIT License**. Tự do sử dụng, chỉnh sửa và chia sẻ cho cộng đồng.
