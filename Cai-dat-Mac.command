#!/usr/bin/env bash
# ==============================================================================
#  HuyNex Workstation - Cau Noi Cai Dat 1-Click (macOS)
#  Tu dong tai ban moi nhat tu GitHub huylinhhg/huynex-workstation
# ==============================================================================
clear
echo "================================================================="
echo "   HUYNEX WORKSTATION 1-CLICK SETUP (macOS)"
echo "   Dang ket noi GitHub va tai ban toi uu moi nhat..."
echo "================================================================="
echo ""

curl -fsSL https://raw.githubusercontent.com/huylinhhg/huynex-workstation/main/setup-mac.sh | bash

echo ""
echo "================================================================="
echo "   HOAN TAT CAI DAT VA TOI UU HE THONG!"
echo "================================================================="
echo "Ban co muon xoa thu muc cai dat tam nay cho may gon gang khong?"
echo "   [Enter] = Xoa ngay (Gon gang sach se)"
echo "   [n]     = Giu lai (De sau nay chay lai khi can cap nhat)"
read -r -p "Lua chon cua ban [Y/n]: " choice

choice=${choice:-y}
if [[ "$choice" =~ ^[Yy]$ ]]; then
    DIR="$(cd "$(dirname "$0")" && pwd)"
    echo ""
    echo "Dang don dep thu muc: $DIR"
    (sleep 1 && rm -rf "$DIR") &
    echo "Da xoa sach thu muc cai dat. Cua so se tu dong sau 3 giay!"
    sleep 3
    exit 0
else
    echo ""
    echo "Da giu lai file cai dat tren may. Ban co the chay lai bat ky luc nao!"
    read -n 1 -s -r -p "Nhan phim bat ky de ket thuc..."
    echo ""
fi
