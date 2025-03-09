#!/bin/bash

# Mô-đun xử lý file log
# Quản lý việc dọn dẹp các file log của hệ thống và ứng dụng

# Mức độ nghiêm trọng
SEVERITY_LOW="${GREEN}THẤP${NC}"
SEVERITY_MEDIUM="${YELLOW}TRUNG BÌNH${NC}"
SEVERITY_HIGH="${RED}CAO${NC}"

# Hàm chính để dọn dẹp file log
clean_logs() {
    print_message "Kiểm tra các file log..."
    
    # Log của hệ thống
    description="File log của hệ thống"
    reason="File log chứa thông tin ghi lại hoạt động của hệ thống, có thể chiếm nhiều dung lượng theo thời gian"
    impact="Xóa file log không ảnh hưởng đến hoạt động của hệ thống, nhưng có thể gây khó khăn khi cần debug vấn đề"
    severity="$SEVERITY_MEDIUM"

    echo -e "${YELLOW}File log của hệ thống${NC}"
    echo -e "\n${PURPLE}=== THÔNG TIN CHI TIẾT ===${NC}"
    echo -e "${CYAN}Mô tả:${NC} $description"
    echo -e "${CYAN}Đường dẫn:${NC} /var/log và /Library/Logs"
    echo -e "${CYAN}Lý do xóa:${NC} $reason"
    echo -e "${CYAN}Ảnh hưởng sau khi xóa:${NC} $impact"
    echo -e "${CYAN}Mức độ nghiêm trọng:${NC} $severity"
    echo -e "${PURPLE}=========================${NC}\n"

    read -p "Bạn có muốn xóa không? (y/N): " response
    if [[ "$response" =~ ^[yY][eE][sS]|[yY]$ ]]; then
        sudo rm -rf /var/log/*.log* 2>/dev/null
        sudo rm -rf /Library/Logs/* 2>/dev/null
        print_success "Đã xóa các file log của hệ thống"
    else
        print_message "Đã bỏ qua xóa file log hệ thống"
    fi

    # Log của người dùng
    remove_with_detailed_confirmation "$HOME/Library/Logs" "Log của người dùng" \
        "File log chứa thông tin ghi lại hoạt động của ứng dụng người dùng, có thể chiếm nhiều dung lượng theo thời gian" \
        "Xóa file log không ảnh hưởng đến hoạt động của ứng dụng, nhưng có thể gây khó khăn khi cần debug vấn đề" \
        "$SEVERITY_MEDIUM"
        
    # Có thể dễ dàng thêm các log mới tại đây
} 