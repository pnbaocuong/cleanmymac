#!/bin/bash

# Màu sắc cho output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Hàm hiển thị thông báo
print_message() { echo -e "${BLUE}[THÔNG BÁO]${NC} $1"; }

# Hàm hiển thị cảnh báo
print_warning() { echo -e "${YELLOW}[CẢNH BÁO]${NC} $1"; }

# Hàm hiển thị lỗi
print_error() { echo -e "${RED}[LỖI]${NC} $1"; }

# Hàm hiển thị thành công
print_success() { echo -e "${GREEN}[THÀNH CÔNG]${NC} $1"; }

# Làm sạch buffer đầu vào
clear_input_buffer() {
    if [ -t 0 ]; then
        while read -t 1 -n 10000 2>/dev/null; do : ; done
    fi
}

# Hiển thị hướng dẫn sử dụng
print_instructions() {
    echo -e "\n${YELLOW}=== HƯỚNG DẪN SỬ DỤNG ===${NC}"
    echo -e "Bấm ${GREEN}y${NC}: Hiển thị 'yes'"
    echo -e "Bấm ${RED}n${NC}: Hiển thị 'no'"
    echo -e "Bấm ${BLUE}a${NC}: Thoát chương trình"
    echo -e "Nếu bấm phím khác: Yêu cầu nhập lại"
    echo -e "${YELLOW}========================${NC}\n"
}

# Hàm chính xử lý đầu vào từ bàn phím
process_keyboard_input() {
    local key=""
    
    # Xử lý tín hiệu Ctrl+C
    trap 'echo -e "\n${RED}Đã phát hiện tín hiệu hủy (Ctrl+C).${NC}"; echo -e "${RED}Đang thoát chương trình...${NC}"; exit 0;' INT
    
    # Hiển thị hướng dẫn sử dụng
    print_instructions
    
    while true; do
        # Hiển thị prompt
        echo -n "Nhập lựa chọn của bạn (y/n/a): "
        
        # Làm sạch buffer đầu vào
        clear_input_buffer
        
        # Đọc một ký tự từ bàn phím
        read -r key
        
        case "$key" in
            y|Y)
                print_success "Yes"
                ;;
            n|N)
                print_message "No"
                ;;
            a|A)
                print_warning "Đã chọn thoát chương trình"
                echo -e "${RED}Đang thoát...${NC}"
                exit 0
                ;;
            *)
                print_error "Giá trị không hợp lệ! Vui lòng chỉ nhập 'y', 'n' hoặc 'a'"
                ;;
        esac
        
        echo -e "----------------------------"
    done
    
    # Đảm bảo hủy bắt tín hiệu khi kết thúc
    trap - INT
}

# Bắt đầu chạy chương trình
echo -e "${GREEN}=== CHƯƠNG TRÌNH XỬ LÝ PHÍM ===${NC}"
process_keyboard_input 