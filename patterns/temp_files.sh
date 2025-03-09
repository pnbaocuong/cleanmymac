#!/bin/bash

# Mô-đun xử lý file tạm thời
# Quản lý việc dọn dẹp các file tạm thời của hệ thống và ứng dụng

# Mức độ nghiêm trọng
SEVERITY_LOW="${GREEN}THẤP${NC}"
SEVERITY_MEDIUM="${YELLOW}TRUNG BÌNH${NC}"
SEVERITY_HIGH="${RED}CAO${NC}"

# Hàm chính để dọn dẹp file tạm thời
clean_temp_files() {
    print_message "Kiểm tra các file tạm thời..."
    
    # Thư mục tạm thời của hệ thống
    remove_with_detailed_confirmation "$TMPDIR" "Thư mục tạm thời của hệ thống" \
        "Thư mục tạm thời chứa các file tạm thời được tạo bởi hệ thống và ứng dụng" \
        "Xóa các file tạm thời thường không ảnh hưởng đến hệ thống, các file này sẽ được tạo lại khi cần" \
        "$SEVERITY_LOW"

    # Thư mục tạm thời /tmp
    remove_with_detailed_confirmation "/tmp" "Thư mục tạm thời /tmp" \
        "Thư mục /tmp chứa các file tạm thời được tạo bởi hệ thống và ứng dụng" \
        "Xóa các file tạm thời thường không ảnh hưởng đến hệ thống, các file này sẽ được tạo lại khi cần" \
        "$SEVERITY_LOW"
        
    # File tạm thời của ứng dụng
    remove_with_detailed_confirmation "$HOME/Library/Application Support/CrashReporter" "Báo cáo sự cố" \
        "Báo cáo sự cố chứa thông tin về các ứng dụng bị crash, thường không cần thiết cho người dùng thông thường" \
        "Xóa báo cáo sự cố không ảnh hưởng đến hệ thống, nhưng có thể gây khó khăn khi cần debug vấn đề" \
        "$SEVERITY_LOW"

    remove_with_detailed_confirmation "$HOME/Library/Application Support/Google/Chrome/Default/Application Cache" "Cache ứng dụng Chrome" \
        "Cache ứng dụng Chrome lưu trữ dữ liệu ứng dụng web để tải nhanh hơn khi truy cập lại" \
        "Xóa cache ứng dụng Chrome sẽ làm chậm tải ứng dụng web lần đầu, nhưng sẽ được tạo lại tự động. Không mất dữ liệu quan trọng" \
        "$SEVERITY_LOW"
        
    # Có thể dễ dàng thêm các file tạm thời mới tại đây
} 