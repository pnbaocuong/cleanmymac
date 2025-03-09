#!/bin/bash

# Script kiểm tra hàm find_and_remove()

# Import các hàm tiện ích
source "$(dirname "$0")/utils.sh"

# Màu sắc và mức độ nghiêm trọng
SEVERITY_LOW="${GREEN}THẤP${NC}"

# Thư mục kiểm tra
TEST_DIR="$HOME/Downloads"

echo -e "${BLUE}[THÔNG BÁO]${NC} Bắt đầu kiểm tra hàm find_and_remove()..."
echo -e "${BLUE}[THÔNG BÁO]${NC} Sử dụng thư mục kiểm tra: $TEST_DIR"
echo ""

# Gọi hàm find_and_remove() để thử nghiệm
echo -e "${BLUE}[THÔNG BÁO]${NC} Tìm kiếm file .zip cũ hơn 30 ngày..."
find_and_remove "$TEST_DIR" "*.zip" \
    "File nén ZIP cũ (>30 ngày)" \
    "File ZIP cũ thường đã được giải nén và không còn cần thiết" \
    "Không ảnh hưởng đến hệ thống, bạn có thể tải lại nếu cần" \
    "$SEVERITY_LOW" "-mtime +30"

echo -e "\n${GREEN}[THÀNH CÔNG]${NC} Đã hoàn thành kiểm tra hàm find_and_remove()!" 