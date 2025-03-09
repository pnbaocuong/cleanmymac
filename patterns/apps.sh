#!/bin/bash

# Mô-đun xử lý ứng dụng
# Quản lý việc dọn dẹp các ứng dụng không sử dụng

# Mức độ nghiêm trọng
SEVERITY_LOW="${GREEN}THẤP${NC}"
SEVERITY_MEDIUM="${YELLOW}TRUNG BÌNH${NC}"
SEVERITY_HIGH="${RED}CAO${NC}"

# Hàm chính để dọn dẹp ứng dụng
clean_apps() {
    print_message "Kiểm tra các ứng dụng đã tải xuống..."
    
    if [ -d "/Applications" ]; then
        find "/Applications" -name "*.app" -maxdepth 1 -type d | while read app; do
            app_name=$(basename "$app" .app)
            size=$(get_size "$app")
            description="Ứng dụng: $app_name"
            reason="Gỡ bỏ các ứng dụng không sử dụng để giải phóng không gian đĩa"
            impact="Ứng dụng sẽ bị xóa hoàn toàn khỏi hệ thống, bạn sẽ cần cài đặt lại nếu muốn sử dụng"
            severity="$SEVERITY_HIGH"
            
            echo -e "${YELLOW}Tìm thấy ứng dụng:${NC} $app_name (kích thước: $size)"
            
            if confirm_with_details "$description" "$reason" "$impact" "$severity" "$app"; then
                sudo rm -rf "$app" 2>/dev/null
                print_success "Đã gỡ bỏ ứng dụng: $app_name"
            else
                print_message "Đã bỏ qua gỡ bỏ ứng dụng: $app_name"
            fi
        done
    else
        print_warning "Không tìm thấy thư mục Applications"
    fi
    
    # Có thể dễ dàng thêm các loại ứng dụng mới tại đây
} 