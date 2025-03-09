#!/bin/bash

# Mô-đun xử lý Time Machine
# Quản lý việc dọn dẹp các bản sao lưu cũ của Time Machine

# Mức độ nghiêm trọng
SEVERITY_LOW="${GREEN}THẤP${NC}"
SEVERITY_MEDIUM="${YELLOW}TRUNG BÌNH${NC}"
SEVERITY_HIGH="${RED}CAO${NC}"

# Hàm chính để dọn dẹp Time Machine
clean_time_machine() {
    print_message "Kiểm tra các bản sao lưu cũ của Time Machine..."
    
    description="Bản sao lưu cũ của Time Machine"
    reason="Time Machine tạo các bản sao lưu tự động, các bản cũ có thể chiếm nhiều dung lượng"
    impact="Xóa các bản sao lưu cũ sẽ giải phóng không gian đĩa, nhưng bạn sẽ không thể khôi phục dữ liệu từ các bản sao lưu đó"
    severity="$SEVERITY_HIGH"

    echo -e "${YELLOW}Bản sao lưu cũ của Time Machine${NC}"
    echo -e "\n${PURPLE}=== THÔNG TIN CHI TIẾT ===${NC}"
    echo -e "${CYAN}Mô tả:${NC} $description"
    echo -e "${CYAN}Lý do xóa:${NC} $reason"
    echo -e "${CYAN}Ảnh hưởng sau khi xóa:${NC} $impact"
    echo -e "${CYAN}Mức độ nghiêm trọng:${NC} $severity"
    echo -e "${PURPLE}=========================${NC}\n"

    read -p "Bạn có muốn xóa không? (y/N): " response
    if [[ "$response" =~ ^[yY][eE][sS]|[yY]$ ]]; then
        print_message "Đang xóa các bản sao lưu cũ của Time Machine..."
        sudo tmutil deletelocalsnapshots / 2>/dev/null
        print_success "Đã xóa các bản sao lưu cũ của Time Machine"
    else
        print_message "Đã bỏ qua xóa bản sao lưu Time Machine"
    fi
} 