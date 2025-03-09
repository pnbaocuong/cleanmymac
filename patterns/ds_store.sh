#!/bin/bash

# Mô-đun xử lý file DS_Store
# Quản lý việc dọn dẹp các file .DS_Store

# Mức độ nghiêm trọng
SEVERITY_LOW="${GREEN}THẤP${NC}"
SEVERITY_MEDIUM="${YELLOW}TRUNG BÌNH${NC}"
SEVERITY_HIGH="${RED}CAO${NC}"

# Hàm chính để dọn dẹp file DS_Store
clean_ds_store() {
    print_message "Kiểm tra các file .DS_Store..."
    
    description="File .DS_Store"
    reason="File .DS_Store là file ẩn được tạo bởi Finder để lưu trữ thông tin hiển thị thư mục"
    impact="Xóa file .DS_Store không ảnh hưởng đến hệ thống, các file này sẽ được tạo lại tự động"
    severity="$SEVERITY_LOW"

    # Hỏi xác nhận trước khi tìm kiếm
    echo -e "${YELLOW}Tìm kiếm file .DS_Store${NC}"
    echo -e "\n${PURPLE}=== THÔNG TIN CHI TIẾT ===${NC}"
    echo -e "${CYAN}Mô tả:${NC} $description"
    echo -e "${CYAN}Lý do xóa:${NC} $reason"
    echo -e "${CYAN}Ảnh hưởng sau khi xóa:${NC} $impact"
    echo -e "${CYAN}Mức độ nghiêm trọng:${NC} $severity"
    echo -e "${PURPLE}=========================${NC}\n"

    read -p "Bạn có muốn tìm và xóa các file .DS_Store không? (y/N): " response
    if [[ "$response" =~ ^[yY][eE][sS]|[yY]$ ]]; then
        # Tìm và xóa từng file .DS_Store
        find "$HOME" -name ".DS_Store" -type f | while read file; do
            if [ -e "$file" ]; then
                size=$(get_size "$file")
                echo -e "${YELLOW}Tìm thấy file .DS_Store:${NC} $file (kích thước: $size)"
                
                read -p "Bạn có muốn xóa file này không? (y/N): " file_response
                if [[ "$file_response" =~ ^[yY][eE][sS]|[yY]$ ]]; then
                    rm -f "$file" 2>/dev/null
                    if [ $? -eq 0 ]; then
                        print_success "Đã xóa: $file"
                    else
                        print_error "Không thể xóa: $file"
                    fi
                else
                    print_message "Đã bỏ qua: $file"
                fi
            fi
        done
    else
        print_message "Đã bỏ qua tìm kiếm và xóa file .DS_Store"
    fi
} 