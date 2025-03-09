#!/bin/bash

# Mô-đun xử lý công cụ phát triển
# Quản lý việc dọn dẹp các file tạm thời của công cụ phát triển

# Mức độ nghiêm trọng
SEVERITY_LOW="${GREEN}THẤP${NC}"
SEVERITY_MEDIUM="${YELLOW}TRUNG BÌNH${NC}"
SEVERITY_HIGH="${RED}CAO${NC}"

# Hàm chính để dọn dẹp công cụ phát triển
clean_dev_tools() {
    print_message "Kiểm tra các file tạm thời của công cụ phát triển..."
    
    # Xcode
    if [ -d "$HOME/Library/Developer/Xcode/DerivedData" ]; then
        remove_with_detailed_confirmation "$HOME/Library/Developer/Xcode/DerivedData" "Dữ liệu phái sinh của Xcode" \
            "Dữ liệu phái sinh của Xcode chứa các file build tạm thời, có thể chiếm rất nhiều dung lượng" \
            "Xóa dữ liệu này không ảnh hưởng đến dự án, chỉ làm chậm lần build đầu tiên sau khi xóa" \
            "$SEVERITY_LOW"
    else
        print_info "Không tìm thấy dữ liệu phái sinh của Xcode"
    fi

    # npm
    if [ -d "$HOME/.npm" ]; then
        remove_with_detailed_confirmation "$HOME/.npm" "Cache của npm" \
            "Cache của npm lưu trữ các package đã tải xuống, có thể chiếm nhiều dung lượng theo thời gian" \
            "Xóa cache npm không ảnh hưởng đến dự án, chỉ làm chậm lần cài đặt package đầu tiên sau khi xóa" \
            "$SEVERITY_LOW"
    else
        print_info "Không tìm thấy cache của npm"
    fi

    # yarn
    if [ -d "$HOME/.yarn/cache" ]; then
        remove_with_detailed_confirmation "$HOME/.yarn/cache" "Cache của yarn" \
            "Cache của yarn lưu trữ các package đã tải xuống, có thể chiếm nhiều dung lượng theo thời gian" \
            "Xóa cache yarn không ảnh hưởng đến dự án, chỉ làm chậm lần cài đặt package đầu tiên sau khi xóa" \
            "$SEVERITY_LOW"
    else
        print_info "Không tìm thấy cache của yarn"
    fi
    
    # Có thể dễ dàng thêm các công cụ phát triển mới tại đây
} 