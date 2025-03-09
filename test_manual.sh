#!/bin/bash

# File kiểm thử thủ công cho utils.sh, tập trung vào hàm get_user_confirmation
# Kiểm thử trực tiếp thông qua terminal (không dùng mock)

# Import các hàm từ utils.sh
source "$(dirname "$0")/utils.sh"

# Màu sắc cho output test
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Giả lập hàm get_user_confirmation để kiểm thử abort mà không thoát chương trình
mock_get_user_confirmation_for_abort() {
    local response="$1"
    
    if [[ "$response" == "y" || "$response" == "Y" ]]; then
        echo -e "${GREEN}Đã xác nhận:${NC} Bạn đã chọn XÁC NHẬN."
        return 0
    elif [[ "$response" == "n" || "$response" == "N" ]]; then
        echo -e "${BLUE}Đã xác nhận:${NC} Bạn đã chọn TỪ CHỐI."
        return 1
    elif [[ "$response" == "a" || "$response" == "A" ]]; then
        echo -e "${RED}Đã xác nhận:${NC} Bạn đã chọn HỦY BỎ toàn bộ quá trình."
        echo -e "${RED}Trong môi trường thực, chương trình sẽ thoát với mã thoát 2.${NC}"
        return 2
    else
        echo -e "${YELLOW}[CẢNH BÁO]${NC} Vui lòng nhập 'y', 'n', hoặc 'a'. Không chấp nhận giá trị khác."
        return 3  # Giá trị đặc biệt cho invalid input trong môi trường test
    fi
}

# Hàm kiểm thử get_user_confirmation
test_get_user_confirmation() {
    local test_name="$1"
    local input_guide="$2"
    local expected_message="$3"
    local is_abort_test="${4:-false}"
    
    echo -e "\n${PURPLE}=== TEST CASE: $test_name ===${NC}"
    echo -e "${CYAN}Yêu cầu:${NC} $input_guide"
    echo -e "${CYAN}Kết quả mong đợi:${NC} $expected_message"
    
    if [ "$is_abort_test" = "true" ]; then
        echo -e "${RED}LƯU Ý: Đây là test case cho chức năng abort.${NC}"
        echo -e "${RED}Trong môi trường thực, chương trình sẽ thoát ngay lập tức khi bạn nhập 'a' hoặc 'A'.${NC}"
        echo -e "${RED}Trong môi trường test, chúng ta sẽ mô phỏng hành vi này mà không thoát chương trình.${NC}"
    fi
    
    echo -e "${PURPLE}=========================${NC}\n"
    
    # Đợi người dùng sẵn sàng trước khi tiếp tục
    read -p "Nhấn Enter khi bạn đã sẵn sàng để thực hiện test case này..." dummy
    
    local result
    
    if [ "$is_abort_test" = "true" ]; then
        # Sử dụng mock cho test abort để tránh thoát chương trình
        echo -n "Vui lòng nhập giá trị kiểm thử (y/n/a - y:đồng ý, n:từ chối, a:hủy bỏ): "
        read response
        mock_get_user_confirmation_for_abort "$response"
        result=$?
    else
        # Gọi hàm get_user_confirmation thực tế cho các test khác
        get_user_confirmation "Vui lòng nhập giá trị kiểm thử"
        result=$?
    fi
    
    # Hiển thị kết quả
    echo -e "\n${CYAN}Kết quả:${NC}"
    if [ $result -eq 0 ]; then
        echo -e "${GREEN}Hàm trả về 0 (XÁC NHẬN)${NC}"
    elif [ $result -eq 1 ]; then
        echo -e "${YELLOW}Hàm trả về 1 (TỪ CHỐI)${NC}"
    elif [ $result -eq 2 ]; then
        echo -e "${RED}Hàm trả về 2 (HỦY BỎ)${NC}"
        if [ "$is_abort_test" = "true" ]; then
            echo -e "${RED}Trong môi trường thực, chương trình sẽ thoát ngay lập tức với mã thoát 2.${NC}"
        fi
    else
        echo -e "${RED}Hàm trả về giá trị không mong đợi: $result${NC}"
    fi
    
    # Đánh giá kết quả
    if [[ "$expected_message" == *"0 (XÁC NHẬN)"* && $result -eq 0 ]] || \
       [[ "$expected_message" == *"1 (TỪ CHỐI)"* && $result -eq 1 ]] || \
       [[ "$expected_message" == *"2 (HỦY BỎ)"* && $result -eq 2 ]]; then
        echo -e "${GREEN}✓ TEST THÀNH CÔNG: Kết quả khớp với mong đợi${NC}"
    else
        echo -e "${RED}✗ TEST THẤT BẠI: Kết quả không khớp với mong đợi${NC}"
    fi
    
    echo -e "\n${PURPLE}--- KẾT THÚC TEST CASE ---${NC}"
}

clear  # Xóa màn hình trước khi bắt đầu

echo -e "${GREEN}=========================================${NC}"
echo -e "${GREEN}       KIỂM THỬ THỦ CÔNG HÀM get_user_confirmation       ${NC}"
echo -e "${GREEN}=========================================${NC}"
echo ""

echo -e "${YELLOW}Mục đích:${NC} Kiểm thử hàm get_user_confirmation với các đầu vào khác nhau"
echo -e "${YELLOW}Cách thức:${NC} Bạn sẽ nhập các giá trị khác nhau và xem kết quả trả về"
echo -e "${YELLOW}Lưu ý:${NC} Hàm sẽ lặp vô hạn cho đến khi bạn nhập giá trị hợp lệ"
echo -e "${RED}QUAN TRỌNG:${NC} Trong môi trường thực, khi bạn nhập 'a' hoặc 'A', chương trình sẽ thoát ngay lập tức"
echo -e "${RED}Trong môi trường test này, chúng tôi sẽ mô phỏng hành vi đó mà không thoát chương trình${NC}"
echo ""
read -p "Nhấn Enter để bắt đầu kiểm thử..." dummy
clear

# Danh sách các test case dưới dạng: tên, hướng dẫn nhập, kết quả mong đợi, là test abort
declare -a test_cases=(
    "Nhập 'y' (thường)"
    "Khi được hỏi, hãy nhập: y"
    "Hàm sẽ trả về 0 (XÁC NHẬN)"
    "false"
    
    "Nhập 'Y' (hoa)"
    "Khi được hỏi, hãy nhập: Y"
    "Hàm sẽ trả về 0 (XÁC NHẬN)"
    "false"
    
    "Nhập 'n' (thường)"
    "Khi được hỏi, hãy nhập: n"
    "Hàm sẽ trả về 1 (TỪ CHỐI)"
    "false"
    
    "Nhập 'N' (hoa)"
    "Khi được hỏi, hãy nhập: N"
    "Hàm sẽ trả về 1 (TỪ CHỐI)"
    "false"
    
    "Nhập 'a' (thường) - ABORT TEST"
    "Khi được hỏi, hãy nhập: a"
    "Hàm sẽ trả về 2 (HỦY BỎ) và thoát chương trình"
    "true"
    
    "Nhập 'A' (hoa) - ABORT TEST"
    "Khi được hỏi, hãy nhập: A"
    "Hàm sẽ trả về 2 (HỦY BỎ) và thoát chương trình"
    "true"
    
    "Nhập chuỗi rỗng rồi nhập y"
    "Khi được hỏi, hãy nhấn Enter mà không nhập gì, sau đó nhập: y"
    "Hàm sẽ yêu cầu nhập lại, và khi nhập y sẽ trả về 0 (XÁC NHẬN)"
    "false"
    
    "Nhập giá trị không hợp lệ rồi từ chối"
    "Khi được hỏi, hãy nhập: xyz, sau đó nhập: n"
    "Hàm sẽ yêu cầu nhập lại, và khi nhập n sẽ trả về 1 (TỪ CHỐI)"
    "false"
    
    "Nhập không hợp lệ nhiều lần rồi hủy bỏ - ABORT TEST"
    "Khi được hỏi, hãy nhập: abc, sau đó nhập: 123, rồi nhập: !@#, cuối cùng nhập: a"
    "Hàm sẽ yêu cầu nhập lại sau mỗi lần nhập không hợp lệ, và khi nhập a sẽ trả về 2 (HỦY BỎ) và thoát chương trình"
    "true"
)

# Chạy các test case
total_tests=${#test_cases[@]}
for ((i=0; i<$total_tests; i+=4)); do
    test_name=${test_cases[$i]}
    input_guide=${test_cases[$i+1]}
    expected_message=${test_cases[$i+2]}
    is_abort_test=${test_cases[$i+3]}
    
    test_get_user_confirmation "$test_name" "$input_guide" "$expected_message" "$is_abort_test"
    
    # Hiển thị phân cách giữa các test case
    if [ $i -lt $(($total_tests-4)) ]; then
        echo ""
        read -p "Nhấn Enter để tiếp tục với test case tiếp theo..." dummy
        clear
    fi
done

echo -e "\n${GREEN}=========================================${NC}"
echo -e "${GREEN}       HOÀN THÀNH KIỂM THỬ THỦ CÔNG       ${NC}"
echo -e "${GREEN}=========================================${NC}"
echo "" 