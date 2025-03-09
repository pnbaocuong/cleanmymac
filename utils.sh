#!/bin/bash

# Màu sắc cho output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'
# Màu đỏ đậm cho đường dẫn file
BOLD_RED='\033[1;31m'

# Hàm định dạng đường dẫn file với màu đỏ đậm
format_path() {
    echo -e "${BOLD_RED}$1${NC}"
}

# Hàm hiển thị thông báo
print_message() { echo -e "${BLUE}[THÔNG BÁO]${NC} $1"; }

# Hàm hiển thị cảnh báo
print_warning() { echo -e "${YELLOW}[CẢNH BÁO]${NC} $1"; }

# Hàm hiển thị lỗi
print_error() { echo -e "${RED}[LỖI]${NC} $1"; }

# Hàm hiển thị thành công
print_success() { echo -e "${GREEN}[THÀNH CÔNG]${NC} $1"; }

# Hàm hiển thị thông tin
print_info() { echo -e "${CYAN}[THÔNG TIN]${NC} $1"; }

# Hàm làm sạch buffer đầu vào
clear_input_buffer() {
    # Chỉ thực hiện nếu đầu vào là terminal và có thể đọc được
    if [ -t 0 ] && [ -r /dev/tty ]; then
        # Xóa tất cả ký tự đã được nhập mà chưa được xử lý
        # Sử dụng timeout là số nguyên (1) thay vì số thập phân (0.01)
        # Thêm timeout ngắn hơn để tránh treo
        while read -t 0.1 -n 10000 2>/dev/null; do : ; done
    fi
}

# Hàm đọc đầu vào từ bàn phím an toàn
read_keyboard_input() {
    local prompt="$1"
    local key=""
    
    # Hiển thị prompt
    echo -n "$prompt"
    
    # Kiểm tra xem /dev/tty có tồn tại và có thể đọc được không
    if [ -t 0 ] && [ -r /dev/tty ]; then
        # Làm sạch buffer đầu vào
        clear_input_buffer
        
        # Đọc một ký tự từ bàn phím trực tiếp từ stdin
        read -r key
    else
        # Nếu không có terminal tương tác, sử dụng phương pháp thay thế
        read -r key
        print_warning "Không thể sử dụng terminal tương tác, đang sử dụng stdin thông thường."
    fi
    
    # Trả về ký tự đã đọc
    echo "$key"
}

# Hàm hiển thị thông tin chi tiết về file/folder
display_path_info() {
    local path="$1"
    
    # Kiểm tra đường dẫn có tồn tại không
    if [ ! -e "$path" ]; then
        print_error "Đường dẫn $(format_path "$path") không tồn tại!"
        return 1
    fi
    
    # Hiển thị thông tin
    echo -e "\n${YELLOW}THÔNG TIN:${NC}"
    echo -e "Đường dẫn: $(format_path "$path")"
    
    if [ -d "$path" ]; then
        local folder_size=$(get_size "$path")
        echo -e "Loại: ${CYAN}Thư mục${NC}"
        echo -e "Kích thước: ${CYAN}$folder_size${NC}"
        
        # Đếm số lượng file và thư mục con
        local file_count=$(find "$path" -type f | wc -l)
        local dir_count=$(find "$path" -type d | wc -l)
        echo -e "Số file: ${CYAN}$file_count${NC}"
        echo -e "Số thư mục con: ${CYAN}$((dir_count-1))${NC}"
    else
        local file_size=$(get_size "$path")
        echo -e "Loại: ${CYAN}File${NC}"
        echo -e "Kích thước: ${CYAN}$file_size${NC}"
    fi
    
    return 0
}

# Hàm tính kích thước thư mục
get_size() { du -sh "$1" 2>/dev/null | cut -f1; }

# Hàm xóa file/thư mục an toàn
# Nhận vào đường dẫn cần xóa
# Trả về 0 nếu xóa thành công
# Trả về 1 nếu xóa thất bại
# Trả về 2 nếu file/thư mục không tồn tại
safe_remove() {
    local path="$1"
    local is_directory=false
    local type_name="file"
    
    # Kiểm tra sự tồn tại của file/thư mục
    if [ ! -e "$path" ]; then
        print_warning "Đường dẫn $(format_path "$path") không còn tồn tại."
        return 2
    fi
    
    # Xác định loại (file hoặc thư mục)
    if [ -d "$path" ]; then
        is_directory=true
        type_name="thư mục"
        # Sử dụng rm -rf cho thư mục
        rm -rf "$path" 2>/dev/null
    else
        # Sử dụng rm -f cho file thông thường
        rm -f "$path" 2>/dev/null
    fi
    
    # Kiểm tra kết quả xóa
    if [ $? -eq 0 ]; then
        print_success "Đã xóa $type_name: $(format_path "$path")"
        return 0
    else
        print_error "Không thể xóa $type_name: $(format_path "$path")"
        return 1
    fi
}

# Hàm xử lý việc xóa một đường dẫn với xác nhận
delete_path_with_confirmation() {
    local path="$1"
    
    # Hiển thị thông tin về đường dẫn
    display_path_info "$path" || return 4
    
    # Xác nhận lại việc xóa
    echo -e "\n${RED}CẢNH BÁO:${NC} Bạn có chắc chắn muốn xóa $([ -d "$path" ] && echo "thư mục" || echo "file") này không?"
    echo -n "Xác nhận xóa (y/n): "
    local delete_confirmation=""
    read -r delete_confirmation
    
    if [[ "$delete_confirmation" == "y" || "$delete_confirmation" == "Y" ]]; then
        echo -e "${RED}Đang xóa...${NC}"
        
        # Sử dụng hàm safe_remove
        safe_remove "$path"
        local remove_status=$?
        
        if [ $remove_status -eq 0 ]; then
            return 3  # Mã trả về đặc biệt cho biết đã xóa thành công
        else
            return 4  # Mã trả về đặc biệt cho biết không thể xóa
        fi
    else
        print_message "Đã hủy xóa đường dẫn"
        return 4  # Mã trả về đặc biệt cho biết đã từ chối xóa
    fi
}

# Hàm xử lý tùy chọn p (nhập đường dẫn tùy chỉnh)
handle_custom_path_option() {
    echo -e "${PURPLE}Đã xác nhận:${NC} Bạn đã chọn NHẬP ĐƯỜNG DẪN KHÁC."
    
    # Yêu cầu nhập đường dẫn
    echo -n "Vui lòng nhập đường dẫn cần xóa: "
    local custom_path=""
    read -r custom_path
    
    # Kiểm tra đường dẫn có hợp lệ không
    if [ -z "$custom_path" ]; then
        print_warning "Đường dẫn không được để trống!"
        return 5  # Mã trả về đặc biệt cho biết đường dẫn không hợp lệ
    fi
    
    # Xử lý việc xóa đường dẫn
    delete_path_with_confirmation "$custom_path"
    return $?
}

# Hàm nhận xác nhận từ người dùng
# Trả về 0 nếu người dùng chọn xác nhận (y/Y)
# Trả về 1 nếu người dùng chọn từ chối (n/N)
# Trả về 3 nếu người dùng chọn tham số p (p/P) và đã xóa folder thành công
# Trả về 4 nếu người dùng chọn tham số p (p/P) nhưng đã từ chối hoặc không thể xóa folder
# Nếu người dùng chọn hủy bỏ (a/A), thoát luôn chương trình với mã thoát 2
get_user_confirmation() {
    local prompt="${1:-Bạn có muốn tiếp tục không?}"
    local max_attempts=3
    local attempt=1
    
    # Xử lý tín hiệu Ctrl+C (SIGINT)
    trap 'echo -e "\n${RED}Đã phát hiện tín hiệu hủy (Ctrl+C).${NC}"; echo -e "${RED}Đang thoát chương trình...${NC}"; exit 2;' INT
    
    while true; do
        # Hiển thị prompt và đọc đầu vào từ bàn phím
        echo -n "$prompt (y/n/a/p - y:đồng ý, n:từ chối, a:hủy bỏ, p:nhập đường dẫn khác): "
        
        # Đọc một ký tự từ bàn phím
        local key=""
        read -r key
        
        case "$key" in
            y|Y)
                echo -e "${GREEN}Đã xác nhận:${NC} Bạn đã chọn XÁC NHẬN."
                # Hủy bắt tín hiệu khi kết thúc hàm
                trap - INT
                return 0
                ;;
            n|N)
                echo -e "${BLUE}Đã xác nhận:${NC} Bạn đã chọn TỪ CHỐI."
                # Hủy bắt tín hiệu khi kết thúc hàm
                trap - INT
                return 1
                ;;
            a|A)
                echo -e "${RED}Đã xác nhận:${NC} Bạn đã chọn HỦY BỎ toàn bộ quá trình."
                echo -e "${RED}Đang thoát chương trình...${NC}"
                # Không cần hủy bắt tín hiệu vì chúng ta đang thoát
                exit 2
                ;;
            p|P)
                # Xử lý tùy chọn nhập đường dẫn tùy chỉnh
                handle_custom_path_option
                local result=$?
                if [ $result -eq 5 ]; then
                    # Đường dẫn không hợp lệ, tiếp tục vòng lặp
                    continue
                fi
                # Hủy bắt tín hiệu khi kết thúc hàm
                trap - INT
                return $result
                ;;
            "")
                # Xử lý trường hợp không nhập gì
                if [ $attempt -ge $max_attempts ]; then
                    print_warning "Đã không nhập gì $max_attempts lần. Mặc định chuyển sang từ chối."
                    echo -e "${BLUE}Đã xác nhận:${NC} Mặc định TỪ CHỐI."
                    # Hủy bắt tín hiệu khi kết thúc hàm
                    trap - INT
                    return 1
                else
                    print_warning "Vui lòng nhập 'y', 'n', 'a', hoặc 'p'. Không được để trống. (Lần thử $attempt/$max_attempts)"
                    ((attempt++))
                fi
                ;;
            *)
                # Nếu người dùng nhập không hợp lệ
                if [ $attempt -ge $max_attempts ]; then
                    print_warning "Đã nhập không hợp lệ '$key' $max_attempts lần. Mặc định chuyển sang từ chối."
                    echo -e "${BLUE}Đã xác nhận:${NC} Mặc định TỪ CHỐI."
                    # Hủy bắt tín hiệu khi kết thúc hàm
                    trap - INT
                    return 1
                else
                    print_warning "Vui lòng nhập 'y', 'n', 'a', hoặc 'p'. Không chấp nhận giá trị '$key'. (Lần thử $attempt/$max_attempts)"
                    ((attempt++))
                fi
                ;;
        esac
    done
    
    # Đảm bảo hủy bắt tín hiệu khi kết thúc hàm
    trap - INT
}

# Hàm nhập mật khẩu an toàn (không hiển thị ký tự khi nhập)
read_password() {
    local prompt="$1"
    local password=""
    
    # Kiểm tra xem có đầu vào từ stdin không (cho testing)
    if [ -t 0 ]; then
        # Kiểm tra xem /dev/tty có tồn tại và có thể đọc được không
        if [ -r /dev/tty ]; then
            # Mở descriptor số 3 cho /dev/tty để đảm bảo đọc đầu vào từ terminal
            exec 3</dev/tty
            
            # Làm sạch buffer đầu vào ngay trước khi đọc
            clear_input_buffer
            
            # Đầu vào từ terminal - ẩn ký tự khi nhập
            echo -n "$prompt: " >&2  # Ghi prompt vào stderr để không ảnh hưởng đến output chính
            read -s password <&3
            echo "" >&2  # Xuống dòng sau khi nhập mật khẩu (ghi vào stderr)
            
            # Đóng file descriptor
            exec 3<&-
        else
            # Nếu không có /dev/tty, sử dụng stdin thông thường
            echo -n "$prompt: " >&2
            read -s password
            echo "" >&2
            print_warning "Không thể sử dụng /dev/tty, đang sử dụng stdin thông thường."
        fi
    else
        # Đầu vào không phải từ terminal (ví dụ: pipe từ echo) - không ẩn ký tự
        # Trong trường hợp kiểm thử, không hiển thị prompt
        read password
    fi
    
    # Trả về mật khẩu
    echo "$password"
}

# Hàm kiểm tra mật khẩu hợp lệ với yêu cầu xác nhận
verify_password() {
    local prompt="$1"
    local confirm_prompt="$2"
    local min_length="${3:-8}"  # Độ dài tối thiểu, mặc định là 8
    
    while true; do
        # Nhập mật khẩu
        local password=$(read_password "$prompt")
        
        # Kiểm tra độ dài mật khẩu
        if [ ${#password} -lt $min_length ]; then
            print_error "Mật khẩu phải có ít nhất $min_length ký tự!"
            continue
        fi
        
        # Xác nhận mật khẩu
        local confirm_password=$(read_password "$confirm_prompt")
        
        # Kiểm tra mật khẩu khớp nhau
        if [ "$password" != "$confirm_password" ]; then
            print_error "Mật khẩu không khớp! Vui lòng thử lại."
            continue
        fi
        
        # Mật khẩu hợp lệ
        print_success "Mật khẩu hợp lệ!"
        echo "$password"
        break
    done
}

# Hàm xác nhận từ người dùng với thông tin chi tiết
confirm_with_details() {
    local description="$1"
    local reason="$2"
    local impact="$3"
    local severity="$4"
    local path="$5"

    echo -e "\n${PURPLE}=== THÔNG TIN CHI TIẾT ===${NC}"
    echo -e "${CYAN}Mô tả:${NC} $description"
    echo -e "${CYAN}Đường dẫn:${NC} $(format_path "$path")"
    echo -e "${CYAN}Lý do xóa:${NC} $reason"
    echo -e "${CYAN}Ảnh hưởng sau khi xóa:${NC} $impact"
    echo -e "${CYAN}Mức độ nghiêm trọng:${NC} $severity"
    echo -e "${PURPLE}=========================${NC}\n"

    echo -e "${YELLOW}CHỜ XÁC NHẬN:${NC} Vui lòng nhập 'y' để xóa, 'n' để bỏ qua, 'a' để hủy bỏ và thoát, hoặc 'p' để nhập đường dẫn khác"
    echo -e "${YELLOW}Lưu ý:${NC} Nếu bạn nhấn Enter mà không nhập gì, hệ thống sẽ yêu cầu nhập lại"

    # Lấy xác nhận từ người dùng - Lưu ý: nếu người dùng chọn 'a', chương trình sẽ thoát ngay lập tức
    local result
    get_user_confirmation "Bạn có muốn xóa không?"
    result=$?
    
    # Kiểm tra và ghi nhật ký kết quả xác nhận
    if [ $result -eq 0 ]; then
        print_info "Đã nhận xác nhận: XÁC NHẬN xóa"
    elif [ $result -eq 1 ]; then
        print_info "Đã nhận xác nhận: TỪ CHỐI xóa"
    elif [ $result -eq 3 ]; then
        print_info "Đã nhận xác nhận: XÓA THÀNH CÔNG đường dẫn tùy chỉnh"
        # Trả về false để bỏ qua việc xóa file hiện tại
        return 1
    elif [ $result -eq 4 ]; then
        print_info "Đã nhận xác nhận: KHÔNG XÓA đường dẫn tùy chỉnh"
        # Trả về false để bỏ qua việc xóa file hiện tại
        return 1
    fi
    
    # Trả về kết quả xác nhận
    return $result
}

# Hàm xóa file/thư mục với xác nhận chi tiết
remove_with_detailed_confirmation() {
    local path="$1"
    local description="$2"
    local reason="$3"
    local impact="$4"
    local severity="$5"

    if [ -e "$path" ]; then
        local size=$(get_size "$path")
        echo -e "${YELLOW}Tìm thấy:${NC} $description (kích thước: $size)"
        echo -e "${YELLOW}Đường dẫn:${NC} $(format_path "$path")"

        if confirm_with_details "$description" "$reason" "$impact" "$severity" "$path"; then
            # Sử dụng hàm safe_remove
            safe_remove "$path"
        else
            print_message "Đã bỏ qua: $(format_path "$path")"
        fi
    fi
}

# Hàm tìm và xóa file với xác nhận
find_and_remove() {
    local search_dir="$1"
    local pattern="$2"
    local description="$3"
    local reason="$4"
    local impact="$5"
    local severity="$6"
    local extra_find_args="$7"

    print_message "Đang tìm kiếm $description trong $(format_path "$search_dir")..."
    print_message "Quá trình tìm kiếm có thể mất một chút thời gian, vui lòng đợi..."

    # Thêm xử lý tín hiệu Ctrl+C cho toàn bộ quá trình tìm kiếm
    trap 'echo -e "\n${RED}Đã phát hiện tín hiệu hủy (Ctrl+C).${NC}"; echo -e "${RED}Đang thoát quá trình tìm kiếm...${NC}"; return 1;' INT

    # Hiển thị thông báo đang tìm kiếm
    echo -n "Đang tìm kiếm"
    
    # Lưu danh sách file tìm thấy vào một mảng để tránh vấn đề với pipe và stdin
    local file_list=()
    local file_count=0
    
    # Sử dụng find với xử lý từng file để hiển thị tiến trình
    while IFS= read -r file_path; do
        if [ -e "$file_path" ]; then
            file_list+=("$file_path")
            ((file_count++))
            
            # Hiển thị dấu chấm để biểu thị tiến trình
            if [ $((file_count % 10)) -eq 0 ]; then
                echo -n "."
            fi
        fi
    done < <(eval "find \"$search_dir\" -name \"$pattern\" $extra_find_args -type f")
    
    # Xuống dòng sau khi hiển thị dấu chấm
    echo ""
    
    # Kiểm tra xem có file nào được tìm thấy không
    if [ ${#file_list[@]} -eq 0 ]; then
        print_warning "Không tìm thấy file nào phù hợp với mẫu \"$pattern\" trong $(format_path "$search_dir")"
        trap - INT
        return 0
    fi
    
    # Hiển thị số lượng file tìm thấy
    print_info "Đã tìm thấy ${#file_list[@]} file phù hợp"
    
    # Đếm số lượng file đã xử lý và số lượng file không tồn tại
    local processed_count=0
    local not_exist_count=0
    local skipped_count=0
    
    # Xử lý từng file
    for file in "${file_list[@]}"; do
        # Kiểm tra lại file có tồn tại không trước khi xử lý (có thể đã bị xóa bởi ứng dụng khác)
        if [ ! -e "$file" ]; then
            print_warning "File $(format_path "$file") không còn tồn tại, bỏ qua."
            ((not_exist_count++))
            continue
        fi
        
        local size=$(get_size "$file")
        echo -e "\n${YELLOW}Tìm thấy $description:${NC} $(format_path "$file") (kích thước: $size)"

        if confirm_with_details "$description" "$reason" "$impact" "$severity" "$file"; then
            # Kiểm tra lại một lần nữa file có tồn tại không trước khi xóa
            if [ ! -e "$file" ]; then
                print_warning "File $(format_path "$file") không còn tồn tại, bỏ qua."
                ((not_exist_count++))
                continue
            fi
            
            # Sử dụng hàm safe_remove
            safe_remove "$file"
            local remove_status=$?
            
            if [ $remove_status -eq 0 ]; then
                ((processed_count++))
            elif [ $remove_status -eq 2 ]; then
                ((not_exist_count++))
            fi
        else
            print_message "Đã bỏ qua: $(format_path "$file")"
            ((skipped_count++))
        fi
    done
    
    # Hiển thị tổng kết
    echo -e "\n${PURPLE}=== TỔNG KẾT ===${NC}"
    echo -e "Tổng số file tìm thấy: ${CYAN}${#file_list[@]}${NC}"
    echo -e "Số file đã xóa: ${GREEN}$processed_count${NC}"
    echo -e "Số file không tồn tại: ${YELLOW}$not_exist_count${NC}"
    echo -e "Số file đã bỏ qua: ${BLUE}$skipped_count${NC}"
    echo -e "Số file còn lại: ${BLUE}$((${#file_list[@]} - processed_count - not_exist_count - skipped_count))${NC}"
    echo -e "${PURPLE}=============${NC}\n"
    
    # Hủy bắt tín hiệu khi kết thúc hàm
    trap - INT
}

# Hàm xử lý và phân loại cache theo thời gian và kích thước
manage_cache() {
    local cache_dir="$1"
    local cache_name="$2"
    local description="$3"
    
    print_message "Đang phân tích cache trong thư mục: $(format_path "$cache_dir")"
    
    # Kiểm tra thư mục cache có tồn tại không
    if [ ! -d "$cache_dir" ]; then
        print_warning "Thư mục cache không tồn tại!"
        return 1
    }

    echo -e "\n${PURPLE}=== PHÂN LOẠI CACHE ===${NC}"
    echo "1. Cache Cũ (> 30 ngày)"
    echo "2. Cache Mới (≤ 30 ngày)"
    echo "3. Cache Lớn (> 10MB)"
    echo "4. Cache Nhỏ (≤ 10MB)"
    echo "5. Cache Hệ thống"
    echo "6. Cache Ứng dụng"
    echo "7. Cache Trình duyệt"
    echo "8. Cache Tải xuống"
    echo "0. Quay lại"
    
    echo -e "\n${YELLOW}Chọn loại cache bạn muốn xử lý (0-8):${NC}"
    read -r cache_type
    
    case "$cache_type" in
        1) # Cache Cũ
            process_old_cache "$cache_dir"
            ;;
        2) # Cache Mới
            process_new_cache "$cache_dir"
            ;;
        3) # Cache Lớn
            process_large_cache "$cache_dir"
            ;;
        4) # Cache Nhỏ
            process_small_cache "$cache_dir"
            ;;
        5) # Cache Hệ thống
            process_system_cache
            ;;
        6) # Cache Ứng dụng
            process_app_cache
            ;;
        7) # Cache Trình duyệt
            process_browser_cache
            ;;
        8) # Cache Tải xuống
            process_download_cache
            ;;
        0|*)
            return
            ;;
    esac
}

# Hàm xử lý cache cũ
process_old_cache() {
    local cache_dir="$1"
    print_message "Đang xử lý cache cũ (> 30 ngày)..."
    
    # Tìm các file cache cũ hơn 30 ngày
    find "$cache_dir" -type f -mtime +30 > /tmp/old_cache.txt
    
    if [ -s /tmp/old_cache.txt ]; then
        local count=$(wc -l < /tmp/old_cache.txt)
        local size=$(calculate_total_size "/tmp/old_cache.txt")
        
        echo -e "\n${YELLOW}TÌM THẤY CACHE CŨ:${NC}"
        echo -e "Số lượng: ${CYAN}$count file${NC}"
        echo -e "Tổng kích thước: ${CYAN}$size${NC}"
        
        if get_user_confirmation "Bạn có muốn xóa các file cache cũ này không?"; then
            remove_cache_files "/tmp/old_cache.txt" "Cache cũ" "Cache quá hạn có thể xóa an toàn"
        fi
    else
        print_message "Không tìm thấy cache cũ."
    fi
    
    rm -f /tmp/old_cache.txt
}

# Hàm xử lý cache mới
process_new_cache() {
    local cache_dir="$1"
    print_message "Đang xử lý cache mới (≤ 30 ngày)..."
    
    # Tìm các file cache mới hơn hoặc bằng 30 ngày
    find "$cache_dir" -type f -mtime -30 > /tmp/new_cache.txt
    
    if [ -s /tmp/new_cache.txt ]; then
        local count=$(wc -l < /tmp/new_cache.txt)
        local size=$(calculate_total_size "/tmp/new_cache.txt")
        
        echo -e "\n${YELLOW}TÌM THẤY CACHE MỚI:${NC}"
        echo -e "Số lượng: ${CYAN}$count file${NC}"
        echo -e "Tổng kích thước: ${CYAN}$size${NC}"
        
        if get_user_confirmation "Bạn có muốn xóa các file cache mới này không?"; then
            remove_cache_files "/tmp/new_cache.txt" "Cache mới" "Cache đang được sử dụng, xóa có thể ảnh hưởng hiệu suất"
        fi
    else
        print_message "Không tìm thấy cache mới."
    fi
    
    rm -f /tmp/new_cache.txt
}

# Hàm xử lý cache lớn
process_large_cache() {
    local cache_dir="$1"
    print_message "Đang xử lý cache lớn (> 10MB)..."
    
    # Tìm các file cache lớn hơn 10MB
    find "$cache_dir" -type f -size +10M > /tmp/large_cache.txt
    
    if [ -s /tmp/large_cache.txt ]; then
        local count=$(wc -l < /tmp/large_cache.txt)
        local size=$(calculate_total_size "/tmp/large_cache.txt")
        
        echo -e "\n${YELLOW}TÌM THẤY CACHE LỚN:${NC}"
        echo -e "Số lượng: ${CYAN}$count file${NC}"
        echo -e "Tổng kích thước: ${CYAN}$size${NC}"
        
        if get_user_confirmation "Bạn có muốn xóa các file cache lớn này không?"; then
            remove_cache_files "/tmp/large_cache.txt" "Cache lớn" "Cache chiếm nhiều dung lượng"
        fi
    else
        print_message "Không tìm thấy cache lớn."
    fi
    
    rm -f /tmp/large_cache.txt
}

# Hàm xử lý cache nhỏ
process_small_cache() {
    local cache_dir="$1"
    print_message "Đang xử lý cache nhỏ (≤ 10MB)..."
    
    # Tìm các file cache nhỏ hơn hoặc bằng 10MB
    find "$cache_dir" -type f -size -10M > /tmp/small_cache.txt
    
    if [ -s /tmp/small_cache.txt ]; then
        local count=$(wc -l < /tmp/small_cache.txt)
        local size=$(calculate_total_size "/tmp/small_cache.txt")
        
        echo -e "\n${YELLOW}TÌM THẤY CACHE NHỎ:${NC}"
        echo -e "Số lượng: ${CYAN}$count file${NC}"
        echo -e "Tổng kích thước: ${CYAN}$size${NC}"
        
        if get_user_confirmation "Bạn có muốn xóa các file cache nhỏ này không?"; then
            remove_cache_files "/tmp/small_cache.txt" "Cache nhỏ" "Cache không chiếm nhiều dung lượng"
        fi
    else
        print_message "Không tìm thấy cache nhỏ."
    fi
    
    rm -f /tmp/small_cache.txt
}

# Hàm xử lý cache hệ thống
process_system_cache() {
    echo -e "\n${PURPLE}=== CACHE HỆ THỐNG ===${NC}"
    echo "1. Cache Hệ thống chung (/Library/Caches)"
    echo "2. Cache Logs hệ thống (/var/log)"
    echo "3. Cache Temporary Files (/private/tmp)"
    echo "0. Quay lại"
    
    echo -e "\n${YELLOW}Chọn loại cache hệ thống (0-3):${NC}"
    read -r system_type
    
    case "$system_type" in
        1) manage_cache "/Library/Caches" "Cache Hệ thống" "Cache chung của hệ thống" ;;
        2) manage_cache "/var/log" "System Logs" "Nhật ký hệ thống" ;;
        3) manage_cache "/private/tmp" "Temporary Files" "File tạm thời" ;;
        0|*) return ;;
    esac
}

# Hàm xử lý cache ứng dụng
process_app_cache() {
    echo -e "\n${PURPLE}=== CACHE ỨNG DỤNG ===${NC}"
    echo "1. Adobe (Photoshop, Illustrator,...)"
    echo "2. Microsoft Office"
    echo "3. Xcode"
    echo "4. App Store"
    echo "5. Mail"
    echo "6. Messages"
    echo "7. Tìm theo tên ứng dụng"
    echo "0. Quay lại"
    
    echo -e "\n${YELLOW}Chọn ứng dụng (0-7):${NC}"
    read -r app_type
    
    case "$app_type" in
        1) manage_cache "$HOME/Library/Caches/Adobe" "Adobe Cache" "Cache của Adobe" ;;
        2) manage_cache "$HOME/Library/Containers/com.microsoft.Word/Data/Library/Caches" "Office Cache" "Cache của Microsoft Office" ;;
        3) manage_cache "$HOME/Library/Developer/Xcode/DerivedData" "Xcode Cache" "Cache của Xcode" ;;
        4) manage_cache "$HOME/Library/Caches/com.apple.appstore" "App Store Cache" "Cache của App Store" ;;
        5) manage_cache "$HOME/Library/Containers/com.apple.mail/Data/Library/Caches" "Mail Cache" "Cache của Mail" ;;
        6) manage_cache "$HOME/Library/Containers/com.apple.iChat/Data/Library/Caches" "Messages Cache" "Cache của Messages" ;;
        7)
            echo -e "\n${YELLOW}Nhập tên ứng dụng:${NC}"
            read -r app_name
            if [ -n "$app_name" ]; then
                find "$HOME/Library/Caches" -type d -iname "*$app_name*" -exec manage_cache {} "Cache của $app_name" "Cache tìm thấy cho $app_name" \;
            fi
            ;;
        0|*) return ;;
    esac
}

# Hàm xử lý cache trình duyệt
process_browser_cache() {
    echo -e "\n${PURPLE}=== CACHE TRÌNH DUYỆT ===${NC}"
    echo "1. Safari"
    echo "2. Google Chrome"
    echo "3. Firefox"
    echo "4. Opera"
    echo "0. Quay lại"
    
    echo -e "\n${YELLOW}Chọn trình duyệt (0-4):${NC}"
    read -r browser_type
    
    case "$browser_type" in
        1) manage_cache "$HOME/Library/Caches/com.apple.Safari" "Safari Cache" "Cache của Safari" ;;
        2) manage_cache "$HOME/Library/Caches/Google/Chrome" "Chrome Cache" "Cache của Chrome" ;;
        3) manage_cache "$HOME/Library/Caches/Firefox" "Firefox Cache" "Cache của Firefox" ;;
        4) manage_cache "$HOME/Library/Caches/com.operasoftware.Opera" "Opera Cache" "Cache của Opera" ;;
        0|*) return ;;
    esac
}

# Hàm xử lý cache tải xuống
process_download_cache() {
    echo -e "\n${PURPLE}=== CACHE TẢI XUỐNG ===${NC}"
    echo "1. File DMG cũ (> 30 ngày)"
    echo "2. File ZIP cũ (> 30 ngày)"
    echo "3. File PKG cũ (> 30 ngày)"
    echo "4. Tất cả file cũ (> 30 ngày)"
    echo "0. Quay lại"
    
    echo -e "\n${YELLOW}Chọn loại file (0-4):${NC}"
    read -r download_type
    
    case "$download_type" in
        1) find_and_remove "$HOME/Downloads" "*.dmg" "File DMG cũ" "File cài đặt cũ" "Có thể tải lại" "${GREEN}THẤP${NC}" "-mtime +30" ;;
        2) find_and_remove "$HOME/Downloads" "*.zip" "File ZIP cũ" "File nén cũ" "Có thể tải lại" "${GREEN}THẤP${NC}" "-mtime +30" ;;
        3) find_and_remove "$HOME/Downloads" "*.pkg" "File PKG cũ" "File cài đặt cũ" "Có thể tải lại" "${GREEN}THẤP${NC}" "-mtime +30" ;;
        4) find_and_remove "$HOME/Downloads" "*" "File cũ" "File tải xuống cũ" "Có thể tải lại" "${YELLOW}TRUNG BÌNH${NC}" "-mtime +30" ;;
        0|*) return ;;
    esac
}

# Hàm xóa file cache từ danh sách
remove_cache_files() {
    local file_list="$1"
    local description="$2"
    local reason="Cache không cần thiết có thể lấy lại khi cần"
    local impact="Các ứng dụng sẽ tự tạo lại cache khi cần"
    local severity="${YELLOW}TRUNG BÌNH${NC}"
    
    # Đếm số lượng file cần xóa
    local file_count=$(wc -l < "$file_list" | tr -d ' ')
    
    if [ "$file_count" -eq 0 ]; then
        print_warning "Không có file cache nào để xóa."
        return 0
    fi
    
    print_message "Đang chuẩn bị xóa $file_count file cache..."
    
    # Tính tổng kích thước cache sẽ xóa
    local total_size=0
    while IFS= read -r file_path; do
        local file_size=$(du -k "$file_path" 2>/dev/null | cut -f1)
        if [ -n "$file_size" ]; then
            total_size=$((total_size + file_size))
        fi
    done < "$file_list"
    
    # Chuyển đổi kích thước thành đơn vị thích hợp
    local size_display=""
    if [ "$total_size" -gt 1048576 ]; then
        size_display="$(echo "scale=2; $total_size/1048576" | bc) GB"
    elif [ "$total_size" -gt 1024 ]; then
        size_display="$(echo "scale=2; $total_size/1024" | bc) MB"
    else
        size_display="$total_size KB"
    fi
    
    # Xác nhận với người dùng
    echo -e "\n${PURPLE}=== XÁC NHẬN XÓA CACHE ===${NC}"
    echo -e "Loại cache: ${CYAN}$description${NC}"
    echo -e "Số lượng file: ${CYAN}$file_count${NC}"
    echo -e "Tổng kích thước: ${CYAN}$size_display${NC}"
    echo -e "${PURPLE}=========================${NC}\n"
    
    local confirm_message="Bạn có chắc chắn muốn xóa $file_count file cache ($size_display)?"
    
    if get_user_confirmation "$confirm_message"; then
        print_message "Đang xóa cache..."
        
        local success_count=0
        local error_count=0
        
        # Xóa từng file cache
        while IFS= read -r file_path; do
            if [ -e "$file_path" ]; then
                if safe_remove "$file_path"; then
                    ((success_count++))
                else
                    ((error_count++))
                fi
            fi
        done < "$file_list"
        
        # Hiển thị kết quả
        echo -e "\n${PURPLE}=== KẾT QUẢ XÓA CACHE ===${NC}"
        echo -e "Tổng số file: ${CYAN}$file_count${NC}"
        echo -e "Thành công: ${GREEN}$success_count${NC}"
        echo -e "Thất bại: ${RED}$error_count${NC}"
        echo -e "Đã giải phóng: ${GREEN}$size_display${NC}"
        echo -e "${PURPLE}=========================${NC}\n"
    else
        print_message "Đã hủy xóa cache."
    fi
}

# Hàm tính tổng kích thước của từng loại cache
calculate_total_size() {
    local file_list="$1"
    local total_size=0
    
    while IFS= read -r file_path; do
        local file_size=$(du -k "$file_path" 2>/dev/null | cut -f1)
        if [ -n "$file_size" ]; then
            total_size=$((total_size + file_size))
        fi
    done < "$file_list"
    
    # Chuyển đổi kích thước thành đơn vị thích hợp
    if [ "$total_size" -gt 1048576 ]; then
        echo "$(echo "scale=2; $total_size/1048576" | bc) GB"
    elif [ "$total_size" -gt 1024 ]; then
        echo "$(echo "scale=2; $total_size/1024" | bc) MB"
    else
        echo "$total_size KB"
    fi
}

# Hàm quản lý các loại cache khác nhau trên macOS
manage_mac_caches() {
    echo -e "\n${PURPLE}===== Đang thực hiện: Dọn dẹp file cache (1/10) =====${NC}"
    
    # Kiểm tra các file cache
    print_message "Kiểm tra các file cache..."
    local user_cache_dir="$HOME/Library/Caches"
    local total_size=$(get_size "$user_cache_dir")
    echo -e "${YELLOW}Tìm thấy:${NC} Cache của người dùng (kích thước: $total_size)"
    echo -e "${YELLOW}Đường dẫn:${NC} $(format_path "$user_cache_dir")"
    
    echo -e "\n${YELLOW}=== THÔNG TIN CHI TIẾT ===${NC}"
    echo -e "Mô tả: Cache của người dùng"
    echo -e "Đường dẫn: $(format_path "$user_cache_dir")"
    echo -e "Lý do xóa: Cache là bộ nhớ tạm thời lưu trữ dữ liệu để truy cập nhanh hơn, nhưng có thể chiếm nhiều dung lượng"
    echo -e "Ảnh hưởng sau khi xóa: Xóa cache có thể làm chậm một số ứng dụng khi khởi động lần đầu, nhưng sẽ được tạo lại tự động"
    echo -e "Mức độ nghiêm trọng: ${GREEN}THẤP${NC}"
    echo -e "${YELLOW}=========================${NC}\n"

    # Hiển thị menu các loại cache
    echo -e "${PURPLE}=== CÁC LOẠI CACHE CẦN XỬ LÝ ===${NC}"
    echo -e "1. Cache Cũ (> 30 ngày)"
    echo -e "2. Cache Mới (≤ 30 ngày)"
    echo -e "3. Cache Lớn (> 10MB)"
    echo -e "4. Cache Nhỏ (≤ 10MB)"
    echo -e "${PURPLE}=========================${NC}\n"

    # Xử lý theo thứ tự: cũ -> mới -> lớn -> nhỏ
    local steps=("Cache Cũ (> 30 ngày)" "Cache Mới (≤ 30 ngày)" "Cache Lớn (> 10MB)" "Cache Nhỏ (≤ 10MB)")
    local current_step=1

    for step in "${steps[@]}"; do
        echo -e "\n${PURPLE}=====================================${NC}"
        echo -e "${YELLOW}ĐANG XỬ LÝ: ${CYAN}$step${NC}"
        echo -e "${PURPLE}=====================================${NC}"
        
        case $current_step in
            1) 
                echo -e "${CYAN}Mô tả:${NC} Xóa các file cache cũ hơn 30 ngày"
                echo -e "${CYAN}Lý do:${NC} Cache cũ thường không còn cần thiết và có thể xóa an toàn"
                process_old_cache "$user_cache_dir" 
                ;;
            2) 
                echo -e "${CYAN}Mô tả:${NC} Xóa các file cache mới hơn hoặc bằng 30 ngày"
                echo -e "${CYAN}Lý do:${NC} Cache mới đang được sử dụng, cân nhắc kỹ trước khi xóa"
                process_new_cache "$user_cache_dir" 
                ;;
            3) 
                echo -e "${CYAN}Mô tả:${NC} Xóa các file cache lớn hơn 10MB"
                echo -e "${CYAN}Lý do:${NC} Cache lớn chiếm nhiều dung lượng đĩa"
                process_large_cache "$user_cache_dir" 
                ;;
            4) 
                echo -e "${CYAN}Mô tả:${NC} Xóa các file cache nhỏ hơn hoặc bằng 10MB"
                echo -e "${CYAN}Lý do:${NC} Cache nhỏ không chiếm nhiều dung lượng nhưng số lượng có thể lớn"
                process_small_cache "$user_cache_dir" 
                ;;
        esac
        
        echo -e "\n${GREEN}✓ Đã hoàn thành xử lý: $step${NC}"
        ((current_step++))
        
        # Hỏi người dùng có muốn tiếp tục không sau mỗi bước
        if [ $current_step -le 4 ]; then
            echo -e "\n${YELLOW}Bước tiếp theo: ${CYAN}${steps[$current_step-1]}${NC}"
            echo -e "${YELLOW}Bạn có muốn tiếp tục không? (y/n):${NC}"
            read -r continue_choice
            if [[ ! "$continue_choice" =~ ^[Yy]$ ]]; then
                print_message "Đã dừng quá trình dọn dẹp cache."
                return
            fi
        fi
    done

    # Hiển thị tổng kết
    local final_size=$(get_size "$user_cache_dir")
    echo -e "\n${PURPLE}=== TỔNG KẾT TOÀN BỘ QUÁ TRÌNH ===${NC}"
    echo -e "Kích thước ban đầu: ${CYAN}$total_size${NC}"
    echo -e "Kích thước sau khi dọn dẹp: ${CYAN}$final_size${NC}"
    echo -e "Đã hoàn thành quá trình dọn dẹp cache!"
    echo -e "${PURPLE}================================${NC}\n"
} 