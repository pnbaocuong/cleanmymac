#!/bin/bash

# Mô-đun xử lý xác thực
# Quản lý việc xác thực người dùng bằng mật khẩu

# Đường dẫn tới file lưu trữ mật khẩu băm
PASSWORD_FILE="$HOME/.cleanmymac_password"

# Mật khẩu mặc định (admin được băm bằng SHA-256)
DEFAULT_PASSWORD="8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918"

# Hàm tạo mã băm SHA-256 từ chuỗi
hash_password() {
    local password="$1"
    echo -n "$password" | shasum -a 256 | cut -d' ' -f1
}

# Hàm kiểm tra xem file mật khẩu đã tồn tại chưa, nếu chưa thì tạo với mật khẩu mặc định
init_password_file() {
    if [ ! -f "$PASSWORD_FILE" ]; then
        echo "$DEFAULT_PASSWORD" > "$PASSWORD_FILE"
        chmod 600 "$PASSWORD_FILE"  # Đảm bảo chỉ người dùng hiện tại có quyền đọc/ghi
        print_info "File mật khẩu khởi tạo với mật khẩu mặc định 'admin'."
    fi
}

# Hàm lấy mật khẩu băm hiện tại
get_current_password_hash() {
    init_password_file
    cat "$PASSWORD_FILE"
}

# Hàm yêu cầu xác thực trước khi thực hiện các thao tác nguy hiểm
require_authentication() {
    print_message "Xác thực bắt buộc cho thao tác này..."
    
    # Đọc mật khẩu quản trị từ người dùng
    local input_password=$(read_password "Nhập mật khẩu quản trị")
    
    # Băm mật khẩu đầu vào
    local input_hash=$(hash_password "$input_password")
    
    # Lấy mật khẩu băm từ file
    local stored_hash=$(get_current_password_hash)
    
    # So sánh với mật khẩu băm đã lưu
    if [ "$input_hash" == "$stored_hash" ]; then
        print_success "Xác thực thành công!"
        return 0
    else
        print_error "Xác thực thất bại! Mật khẩu không đúng."
        return 1
    fi
}

# Hàm thay đổi mật khẩu quản trị
change_admin_password() {
    print_message "Thay đổi mật khẩu quản trị..."
    
    # Xác thực mật khẩu hiện tại trước
    local current_password=$(read_password "Nhập mật khẩu hiện tại")
    local current_hash=$(hash_password "$current_password")
    local stored_hash=$(get_current_password_hash)
    
    # Kiểm tra mật khẩu hiện tại
    if [ "$current_hash" != "$stored_hash" ]; then
        print_error "Mật khẩu hiện tại không đúng!"
        return 1
    fi
    
    # Nhập và xác nhận mật khẩu mới
    local new_password=$(verify_password "Nhập mật khẩu mới" "Xác nhận mật khẩu mới" 6)
    
    # Băm và lưu mật khẩu mới
    local new_hash=$(hash_password "$new_password")
    echo "$new_hash" > "$PASSWORD_FILE"
    
    print_success "Đã thay đổi mật khẩu quản trị thành công!"
    return 0
}

# Hàm hiển thị thông tin về mật khẩu hiện tại
show_password_info() {
    init_password_file
    
    echo -e "${CYAN}Thông tin mật khẩu:${NC}"
    echo "- File lưu trữ: $PASSWORD_FILE"
    
    if [ "$(get_current_password_hash)" == "$DEFAULT_PASSWORD" ]; then
        print_warning "Bạn đang sử dụng mật khẩu mặc định (admin). Nên thay đổi mật khẩu để tăng tính bảo mật."
    else
        print_info "Bạn đã thay đổi mật khẩu mặc định."
    fi
}

# Hàm đặt lại mật khẩu về mặc định
reset_password() {
    print_message "Đặt lại mật khẩu về mặc định..."
    
    read -p "Bạn có chắc chắn muốn đặt lại mật khẩu về 'admin'? (y/N): " confirm
    if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
        echo "$DEFAULT_PASSWORD" > "$PASSWORD_FILE"
        print_success "Đã đặt lại mật khẩu về mặc định (admin)."
    else
        print_message "Đã hủy việc đặt lại mật khẩu."
    fi
}

# Hàm chính để quản lý xác thực
manage_authentication() {
    # Đảm bảo file mật khẩu đã được tạo
    init_password_file
    
    while true; do
        echo -e "${CYAN}=== QUẢN LÝ XÁC THỰC ===${NC}"
        echo "1. Thay đổi mật khẩu quản trị"
        echo "2. Kiểm tra xác thực"
        echo "3. Hiển thị thông tin mật khẩu"
        echo "4. Đặt lại mật khẩu về mặc định"
        echo "0. Quay lại"
        echo -e "${CYAN}======================${NC}"
        
        read -p "Vui lòng chọn tùy chọn (0-4): " choice
        
        case $choice in
            1) change_admin_password ;;
            2)
                if require_authentication; then
                    print_message "Bạn đã được xác thực thành công!"
                else
                    print_error "Xác thực thất bại!"
                fi
                ;;
            3) show_password_info ;;
            4) reset_password ;;
            0) return ;;
            *) print_error "Lựa chọn không hợp lệ. Vui lòng chọn lại." ;;
        esac
        
        echo ""
        read -p "Nhấn Enter để tiếp tục..."
        echo ""
    done
} 