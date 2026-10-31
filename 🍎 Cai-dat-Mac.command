#!/usr/bin/env bash
# ==============================================================================
#  ⚡ HuyNex Workstation - Cầu Nối Cài Đặt 1-Click (macOS)
#  Tự động tải bản mới nhất từ GitHub huylinhhg/huynex-workstation
# ==============================================================================
clear
echo "================================================================="
echo "   ⚡ HUYNEX WORKSTATION 1-CLICK SETUP (macOS) ⚡"
echo "   Đang kéo bản cài đặt & tối ưu mới nhất từ GitHub..."
echo "================================================================="
echo ""

# Tải và chạy trực tiếp từ GitHub
curl -fsSL https://raw.githubusercontent.com/huylinhhg/huynex-workstation/main/setup-mac.sh | bash

echo ""
echo "================================================================="
echo "   🎉 HOÀN TẤT CÀI ĐẶT & TỐI ƯU HỆ THỐNG!"
echo "================================================================="
echo "💡 Bạn có muốn xóa thư mục cài đặt tạm này cho máy gọn gàng 100% không?"
echo "   [Enter] = Xóa ngay (Gọn gàng sạch sẽ)"
echo "   [n]     = Giữ lại (Để sau này bấm chạy lại khi cần cập nhật)"
read -r -p "👉 Lựa chọn của bạn [Y/n]: " choice

choice=${choice:-y}
if [[ "$choice" =~ ^[Yy]$ ]]; then
    DIR="$(cd "$(dirname "$0")" && pwd)"
    echo ""
    echo "🧹 Đang dọn dẹp thư mục: $DIR"
    (sleep 1 && rm -rf "$DIR") &
    echo "✅ Đã xóa sạch thư mục cài đặt. Cửa sổ này sẽ tự đóng sau 3 giây!"
    sleep 3
    exit 0
else
    echo ""
    echo "👍 Đã giữ lại file cài đặt trên máy. Bạn có thể bấm lại bất kỳ lúc nào!"
    read -n 1 -s -r -p "Nhấn phím bất kỳ để kết thúc..."
    echo ""
fi
