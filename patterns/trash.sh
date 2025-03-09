#!/bin/bash

# Mô-đun xử lý thùng rác
# Quản lý việc dọn dẹp thùng rác

# Mức độ nghiêm trọng
SEVERITY_LOW="${GREEN}THẤP${NC}"
SEVERITY_MEDIUM="${YELLOW}TRUNG BÌNH${NC}"
SEVERITY_HIGH="${RED}CAO${NC}"

# Hàm chính để dọn dẹp thùng rác
clean_trash() {
    print_message "Kiểm tra Thùng rác..."
    TRASH="$HOME/.Trash"
    
    if [ -d "$TRASH" ] && [ "$(ls -A "$TRASH" 2>/dev/null)" ]; then
        size=$(get_size "$TRASH")
        description="Thùng rác"
        reason="Thùng rác chứa các file đã bị xóa nhưng chưa được xóa hoàn toàn khỏi hệ thống"
        impact="Xóa các file trong thùng rác sẽ giải phóng không gian đĩa. Các file này sẽ bị xóa vĩnh viễn và không thể khôi phục"
        severity="$SEVERITY_MEDIUM"
        
        echo -e "${YELLOW}Tìm thấy:${NC} $description (kích thước: $size)"
        
        if confirm_with_details "$description" "$reason" "$impact" "$severity" "$TRASH"; then
            rm -rf "$TRASH"/* 2>/dev/null
            print_success "Đã dọn sạch Thùng rác"
        else
            print_message "Đã bỏ qua dọn Thùng rác"
        fi
    else
        print_success "Thùng rác đã trống"
    fi
} 