#!/bin/bash

# Script để kiểm tra lệnh find

# Set biến môi trường
DOWNLOADS="$HOME/Downloads"

# Màu sắc cho output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}[THÔNG BÁO]${NC} Bắt đầu chạy kiểm tra lệnh find..."
echo -e "${BLUE}[THÔNG BÁO]${NC} Thư mục tìm kiếm: $DOWNLOADS"
echo -e "${YELLOW}[CẢNH BÁO]${NC} Quá trình này có thể mất vài giây, vui lòng đợi..."
echo ""

# Bước 1: Kiểm tra đường dẫn có tồn tại không
if [ ! -d "$DOWNLOADS" ]; then
    echo -e "${RED}[LỖI]${NC} Thư mục Downloads không tồn tại: $DOWNLOADS"
    exit 1
else
    echo -e "${GREEN}[THÀNH CÔNG]${NC} Thư mục Downloads tồn tại: $DOWNLOADS"
fi

# Bước 2: Đếm số lượng file trong thư mục
file_count=$(find "$DOWNLOADS" -type f | wc -l | xargs)
echo -e "${BLUE}[THÔNG BÁO]${NC} Số lượng file trong thư mục Downloads: $file_count"

# Bước 3: Kiểm tra lệnh find với mẫu cụ thể
echo -e "\n${BLUE}[THÔNG BÁO]${NC} Đang tìm kiếm file .dmg trong Downloads..."
dmg_files=$(find "$DOWNLOADS" -name "*.dmg" -type f)
dmg_count=$(echo "$dmg_files" | grep -v "^$" | wc -l | xargs)

if [ $dmg_count -eq 0 ]; then
    echo -e "${YELLOW}[CẢNH BÁO]${NC} Không tìm thấy file .dmg nào"
else
    echo -e "${GREEN}[THÀNH CÔNG]${NC} Tìm thấy $dmg_count file .dmg"
    echo -e "${BLUE}[THÔNG BÁO]${NC} Danh sách file DMG đầu tiên:"
    echo "$dmg_files" | head -5
fi

# Bước 4: Kiểm tra lệnh find với tham số mtime
echo -e "\n${BLUE}[THÔNG BÁO]${NC} Đang tìm kiếm file .zip cũ hơn 30 ngày..."
zip_files=$(find "$DOWNLOADS" -name "*.zip" -type f -mtime +30)
zip_count=$(echo "$zip_files" | grep -v "^$" | wc -l | xargs)

if [ $zip_count -eq 0 ]; then
    echo -e "${YELLOW}[CẢNH BÁO]${NC} Không tìm thấy file .zip nào cũ hơn 30 ngày"
else
    echo -e "${GREEN}[THÀNH CÔNG]${NC} Tìm thấy $zip_count file .zip cũ hơn 30 ngày"
    echo -e "${BLUE}[THÔNG BÁO]${NC} Danh sách file ZIP đầu tiên:"
    echo "$zip_files" | head -5
fi

echo -e "\n${GREEN}[THÀNH CÔNG]${NC} Đã hoàn thành kiểm tra lệnh find!" 