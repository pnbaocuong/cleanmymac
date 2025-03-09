#!/bin/bash

# Script làm sạch máy Mac
# Script này sẽ tìm và xóa các file tạm, cache và file rác khác
# Được tổ chức theo các mô-đun riêng biệt để dễ dàng mở rộng

# Màu sắc cho output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Mức độ nghiêm trọng - khai báo toàn cục
SEVERITY_LOW="${GREEN}THẤP${NC}"
SEVERITY_MEDIUM="${YELLOW}TRUNG BÌNH${NC}"
SEVERITY_HIGH="${RED}CAO${NC}"

# Kiểm tra xem file utils.sh có tồn tại không
UTILS_FILE="./utils.sh"
if [ ! -f "$UTILS_FILE" ]; then
    echo "Không tìm thấy file $UTILS_FILE"
    exit 1
fi

# Source các hàm từ utils.sh
source "$UTILS_FILE"

# Menu chính
echo -e "\n${PURPLE}===== CLEAN MY MAC =====${NC}"
echo -e "1. Dọn dẹp Cache"
echo -e "2. Dọn dẹp Ứng dụng (Đang phát triển)"
echo -e "3. Dọn dẹp File rác (Đang phát triển)"
echo -e "4. Thoát"
echo -e "${PURPLE}=====================${NC}\n"

echo -n "Vui lòng chọn chức năng (1-4): "
read -r choice

case $choice in
    1)
        # Gọi hàm quản lý cache
        manage_mac_caches
        ;;
    2)
        echo -e "${YELLOW}Tính năng đang được phát triển${NC}"
        ;;
    3)
        echo -e "${YELLOW}Tính năng đang được phát triển${NC}"
        ;;
    4)
        echo -e "${GREEN}Cảm ơn bạn đã sử dụng Clean My Mac!${NC}"
        exit 0
        ;;
    *)
        echo -e "${RED}Lựa chọn không hợp lệ!${NC}"
        exit 1
        ;;
esac

# Mức độ nghiêm trọng - khai báo toàn cục
SEVERITY_LOW="${GREEN}THẤP${NC}"
SEVERITY_MEDIUM="${YELLOW}TRUNG BÌNH${NC}"
SEVERITY_HIGH="${RED}CAO${NC}"

# Import các hàm tiện ích
source "$(dirname "$0")/utils.sh"

# Import các mô-đun dọn dẹp
source "$(dirname "$0")/patterns/downloads.sh"
source "$(dirname "$0")/patterns/trash.sh"
source "$(dirname "$0")/patterns/cache.sh"
source "$(dirname "$0")/patterns/logs.sh"
source "$(dirname "$0")/patterns/temp_files.sh"
source "$(dirname "$0")/patterns/apps.sh"
source "$(dirname "$0")/patterns/ds_store.sh"
source "$(dirname "$0")/patterns/dev_tools.sh"
source "$(dirname "$0")/patterns/docker.sh"
source "$(dirname "$0")/patterns/time_machine.sh"
source "$(dirname "$0")/patterns/auth.sh"

# Hiển thị banner
echo -e "${GREEN}=========================================${NC}"
echo -e "${GREEN}       CLEAN MY MAC - CÔNG CỤ LÀM SẠCH       ${NC}"
echo -e "${GREEN}=========================================${NC}"
echo ""

# Kiểm tra quyền sudo
print_message "Kiểm tra quyền quản trị..."
if sudo -v; then
    print_success "Đã có quyền quản trị"
else
    print_warning "Script sẽ chạy mà không có quyền quản trị. Một số tác vụ có thể không hoạt động."
fi

echo ""
print_message "Bắt đầu quá trình làm sạch tự động..."
echo ""

# Yêu cầu xác thực trước khi tiếp tục
print_message "Quá trình dọn dẹp tự động sẽ quét lần lượt tất cả các loại file."
print_message "Bạn sẽ được hỏi xác nhận trước khi xóa từng file cụ thể."
print_message "Bạn có thể hủy bỏ và thoát chương trình bất cứ lúc nào bằng cách nhập 'a' hoặc 'A'."
echo ""

# Mảng chứa tên các tác vụ dọn dẹp
cleanup_tasks=(
    "Dọn dẹp thư mục Downloads" 
    "Dọn dẹp Thùng rác" 
    "Dọn dẹp file cache" 
    "Dọn dẹp file logs" 
    "Dọn dẹp file tạm thời" 
    "Quản lý ứng dụng" 
    "Dọn dẹp file .DS_Store" 
    "Dọn dẹp công cụ phát triển (Xcode, npm, yarn)" 
    "Dọn dẹp Docker" 
    "Dọn dẹp Time Machine"
)

# Mảng chứa tên các hàm dọn dẹp tương ứng
cleanup_functions=(
    "clean_downloads" 
    "clean_trash" 
    "clean_cache" 
    "clean_logs" 
    "clean_temp_files" 
    "clean_apps" 
    "clean_ds_store" 
    "clean_dev_tools" 
    "clean_docker" 
    "clean_time_machine"
)

# Xác nhận bắt đầu quá trình
# Lưu ý: Nếu người dùng chọn abort (a/A), hàm get_user_confirmation sẽ thoát luôn chương trình với mã thoát 2
get_user_confirmation "Bạn có muốn bắt đầu quá trình dọn dẹp không?"
result=$?

if [ $result -eq 0 ]; then
    # Chạy từng tác vụ dọn dẹp
    total_tasks=${#cleanup_tasks[@]}
    for ((i=0; i<$total_tasks; i++)); do
        task_name=${cleanup_tasks[$i]}
        task_function=${cleanup_functions[$i]}
        
        echo ""
        echo -e "${CYAN}===== Đang thực hiện: $task_name ($((i+1))/$total_tasks) =====${NC}"
        echo ""
        
        # Gọi hàm tương ứng
        eval "$task_function"
        
        echo ""
        print_success "Đã hoàn thành: $task_name"
        echo ""
        
        # Pause 1 giây giữa các tác vụ để giảm áp lực lên hệ thống
        sleep 1
    done
else
    print_message "Đã hủy quá trình dọn dẹp."
    exit 0
fi

# Kết thúc
echo ""
echo -e "${GREEN}=========================================${NC}"
echo -e "${GREEN}       QUÁ TRÌNH LÀM SẠCH HOÀN TẤT       ${NC}"
echo -e "${GREEN}=========================================${NC}"
echo ""
print_success "Đã hoàn tất quá trình làm sạch máy Mac của bạn!"
print_message "Hãy khởi động lại máy tính để áp dụng tất cả các thay đổi." 