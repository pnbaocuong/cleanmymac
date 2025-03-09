#!/bin/bash

# Mô-đun xử lý thư mục Downloads
# Quản lý việc dọn dẹp các file không cần thiết trong thư mục Downloads

# Mức độ nghiêm trọng
SEVERITY_LOW="${GREEN}THẤP${NC}"
SEVERITY_MEDIUM="${YELLOW}TRUNG BÌNH${NC}"
SEVERITY_HIGH="${RED}CAO${NC}"

# Hàm chính để dọn dẹp thư mục Downloads
clean_downloads() {
    print_message "Kiểm tra thư mục Downloads..."
    DOWNLOADS="$HOME/Downloads"
    
    if [ ! -d "$DOWNLOADS" ]; then
        print_warning "Không tìm thấy thư mục Downloads tại $DOWNLOADS"
        return
    fi
    
    # Tìm và xóa các file DMG
    find_and_remove "$DOWNLOADS" "*.dmg" \
        "File cài đặt DMG" \
        "File DMG là file cài đặt ứng dụng, sau khi cài đặt xong thường không cần thiết nữa" \
        "Không ảnh hưởng đến hệ thống, bạn có thể tải lại nếu cần" \
        "$SEVERITY_LOW" ""
    
    # Tìm và xóa các file ZIP cũ
    find_and_remove "$DOWNLOADS" "*.zip" \
        "File nén ZIP cũ (>30 ngày)" \
        "File ZIP cũ thường đã được giải nén và không còn cần thiết" \
        "Không ảnh hưởng đến hệ thống, bạn có thể tải lại nếu cần" \
        "$SEVERITY_LOW" "-mtime +30"
    
    # Tìm và xóa các file tải xuống không hoàn chỉnh
    find_and_remove "$DOWNLOADS" "*.download" \
        "File tải xuống không hoàn chỉnh" \
        "File tải xuống không hoàn chỉnh là file đang được tải xuống nhưng bị gián đoạn" \
        "Xóa file này sẽ không ảnh hưởng đến hệ thống, nhưng bạn sẽ cần tải lại từ đầu" \
        "$SEVERITY_LOW" ""
    
    find_and_remove "$DOWNLOADS" "*.part" \
        "File tải xuống không hoàn chỉnh" \
        "File tải xuống không hoàn chỉnh là file đang được tải xuống nhưng bị gián đoạn" \
        "Xóa file này sẽ không ảnh hưởng đến hệ thống, nhưng bạn sẽ cần tải lại từ đầu" \
        "$SEVERITY_LOW" ""
        
    # Có thể dễ dàng thêm các mẫu nhận dạng mới tại đây
} 