#!/bin/bash

# Mô-đun xử lý cache
# Quản lý việc dọn dẹp các file cache khác nhau

# Mức độ nghiêm trọng
SEVERITY_LOW="${GREEN}THẤP${NC}"
SEVERITY_MEDIUM="${YELLOW}TRUNG BÌNH${NC}"
SEVERITY_HIGH="${RED}CAO${NC}"

# Hàm chính để dọn dẹp cache
clean_cache() {
    print_message "Kiểm tra các file cache..."

    # Cache của người dùng
    remove_with_detailed_confirmation "$HOME/Library/Caches" "Cache của người dùng" \
        "Cache là bộ nhớ tạm thời lưu trữ dữ liệu để truy cập nhanh hơn, nhưng có thể chiếm nhiều dung lượng" \
        "Xóa cache có thể làm chậm một số ứng dụng khi khởi động lần đầu, nhưng sẽ được tạo lại tự động. Không mất dữ liệu quan trọng" \
        "$SEVERITY_LOW"

    # Cache của Safari
    remove_with_detailed_confirmation "$HOME/Library/Safari/Cache.db" "Cache của Safari" \
        "Cache của Safari lưu trữ dữ liệu trang web để tải nhanh hơn khi truy cập lại" \
        "Xóa cache Safari sẽ làm chậm tải trang web lần đầu, nhưng sẽ được tạo lại tự động. Không mất dữ liệu quan trọng" \
        "$SEVERITY_LOW"

    # Cache của Chrome
    remove_with_detailed_confirmation "$HOME/Library/Caches/Google/Chrome" "Cache của Chrome" \
        "Cache của Chrome lưu trữ dữ liệu trang web để tải nhanh hơn khi truy cập lại" \
        "Xóa cache Chrome sẽ làm chậm tải trang web lần đầu, nhưng sẽ được tạo lại tự động. Không mất dữ liệu quan trọng" \
        "$SEVERITY_LOW"

    # Cache của Firefox
    remove_with_detailed_confirmation "$HOME/Library/Caches/Firefox" "Cache của Firefox" \
        "Cache của Firefox lưu trữ dữ liệu trang web để tải nhanh hơn khi truy cập lại" \
        "Xóa cache Firefox sẽ làm chậm tải trang web lần đầu, nhưng sẽ được tạo lại tự động. Không mất dữ liệu quan trọng" \
        "$SEVERITY_LOW"
    
    # Có thể dễ dàng thêm các cache mới tại đây
} 