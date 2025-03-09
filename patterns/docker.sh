#!/bin/bash

# Mô-đun xử lý Docker
# Quản lý việc dọn dẹp các file tạm thời của Docker

# Mức độ nghiêm trọng
SEVERITY_LOW="${GREEN}THẤP${NC}"
SEVERITY_MEDIUM="${YELLOW}TRUNG BÌNH${NC}"
SEVERITY_HIGH="${RED}CAO${NC}"

# Hàm chính để dọn dẹp Docker
clean_docker() {
    print_message "Kiểm tra các file tạm thời của Docker..."
    
    # Docker máy ảo
    if [ -d "$HOME/Library/Containers/com.docker.docker" ]; then
        remove_with_detailed_confirmation "$HOME/Library/Containers/com.docker.docker/Data/vms" "Máy ảo Docker" \
            "Máy ảo Docker có thể chiếm rất nhiều dung lượng, đặc biệt nếu bạn có nhiều image" \
            "Xóa máy ảo Docker sẽ xóa tất cả các container và image, bạn sẽ cần tải lại từ đầu" \
            "$SEVERITY_HIGH"
    else
        print_info "Không tìm thấy máy ảo Docker"
    fi
    
    # Có thể thêm lệnh dọn dẹp Docker khác ở đây
    # Ví dụ: docker system prune, docker volume prune, docker image prune
} 