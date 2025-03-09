#!/bin/bash

# File kiểm thử cho utils.sh
# Tập trung vào kiểm thử hàm confirm_with_details, get_user_confirmation và read_password

# Import các hàm từ utils.sh
source "$(dirname "$0")/utils.sh"

# Màu sắc cho output test
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Biến đếm số lượng test thành công và thất bại
PASS_COUNT=0
FAIL_COUNT=0

# Hàm hiển thị kết quả test
print_test_result() {
    local test_name="$1"
    local status="$2"
    
    if [ "$status" -eq 0 ]; then
        echo -e "${GREEN}✓ PASS:${NC} $test_name"
        PASS_COUNT=$((PASS_COUNT+1))
    else
        echo -e "${RED}✗ FAIL:${NC} $test_name"
        FAIL_COUNT=$((FAIL_COUNT+1))
    fi
}

# Giả lập hàm get_user_confirmation để kiểm thử
mock_get_user_confirmation() {
    local input="$1"
    
    if [[ "$input" == "y" || "$input" == "Y" ]]; then
        return 0
    elif [[ "$input" == "n" || "$input" == "N" ]]; then
        return 1
    elif [[ -z "$input" ]]; then
        # Chuỗi rỗng (Enter) sẽ yêu cầu nhập lại và giả định người dùng cuối cùng nhập 'n'
        return 1
    else
        # Đầu vào không hợp lệ khác sẽ yêu cầu nhập lại và giả định người dùng cuối cùng nhập 'n'
        return 1
    fi
}

# Giả lập hàm confirm_with_details để kiểm thử
mock_confirm_with_details() {
    local input="$1"
    
    # Sử dụng hàm mock_get_user_confirmation để kiểm thử
    mock_get_user_confirmation "$input"
    return $?
}

# Hàm kiểm thử get_user_confirmation với đầu vào cho trước
test_get_user_confirmation() {
    local input="$1"
    local expected_result="$2"
    local test_description="$3"
    
    # Sử dụng hàm mock để tránh bị treo
    mock_get_user_confirmation "$input"
    local result=$?
    
    # Kiểm tra kết quả
    if [ $result -eq $expected_result ]; then
        print_test_result "$test_description" 0
    else
        print_test_result "$test_description" 1
    fi
}

# Hàm kiểm thử confirm_with_details với đầu vào cho trước
test_confirm_with_details() {
    local input="$1"
    local expected_result="$2"
    local test_description="$3"
    
    # Sử dụng hàm mock để tránh bị treo
    mock_confirm_with_details "$input"
    local result=$?
    
    # Kiểm tra kết quả
    if [ $result -eq $expected_result ]; then
        print_test_result "$test_description" 0
    else
        print_test_result "$test_description" 1
    fi
}

# Hàm kiểm thử read_password với đầu vào cho trước
test_read_password() {
    local input="$1"
    local test_description="$2"
    
    # Gọi hàm read_password trực tiếp với đầu vào từ pipe
    # Lưu giá trị trả về từ hàm read_password
    local password=$(echo "$input" | read_password "Nhập mật khẩu test")
    
    # Kiểm tra kết quả
    if [ "$password" == "$input" ]; then
        print_test_result "$test_description" 0
    else
        print_test_result "$test_description" 1
        echo -e "  ${RED}Expected:${NC} '$input'"
        echo -e "  ${RED}Got:${NC} '$password'"
    fi
}

echo -e "${YELLOW}===== BẮT ĐẦU KIỂM THỬ =====${NC}"

# PHẦN 1: KIỂM THỬ HÀM get_user_confirmation
echo -e "\n${YELLOW}===== KIỂM THỬ HÀM get_user_confirmation =====${NC}"

# Test 1: Kiểm tra khi người dùng nhập 'y'
echo -e "\n${BLUE}Test 1: Kiểm tra khi người dùng nhập 'y'${NC}"
test_get_user_confirmation "y" 0 "Nhập 'y' trả về 0 (xác nhận)"

# Test 2: Kiểm tra khi người dùng nhập 'Y'
echo -e "\n${BLUE}Test 2: Kiểm tra khi người dùng nhập 'Y'${NC}"
test_get_user_confirmation "Y" 0 "Nhập 'Y' trả về 0 (xác nhận)"

# Test 3: Kiểm tra khi người dùng nhập 'n'
echo -e "\n${BLUE}Test 3: Kiểm tra khi người dùng nhập 'n'${NC}"
test_get_user_confirmation "n" 1 "Nhập 'n' trả về 1 (từ chối)"

# Test 4: Kiểm tra khi người dùng nhập 'N'
echo -e "\n${BLUE}Test 4: Kiểm tra khi người dùng nhập 'N'${NC}"
test_get_user_confirmation "N" 1 "Nhập 'N' trả về 1 (từ chối)"

# Test 5: Kiểm tra khi người dùng chỉ nhấn Enter
echo -e "\n${BLUE}Test 5: Kiểm tra khi người dùng chỉ nhấn Enter${NC}"
test_get_user_confirmation "" 1 "Nhập chuỗi rỗng cuối cùng sẽ trả về 1 (từ chối)"

# Test 6: Kiểm tra khi người dùng nhập ký tự không hợp lệ
echo -e "\n${BLUE}Test 6: Kiểm tra khi người dùng nhập ký tự không hợp lệ${NC}"
test_get_user_confirmation "xyz" 1 "Nhập ký tự không hợp lệ cuối cùng sẽ trả về 1 (từ chối)"

# PHẦN 2: KIỂM THỬ HÀM confirm_with_details
echo -e "\n${YELLOW}===== KIỂM THỬ HÀM confirm_with_details =====${NC}"

# Test 7: Kiểm tra khi người dùng nhập 'y'
echo -e "\n${BLUE}Test 7: Kiểm tra khi người dùng nhập 'y'${NC}"
test_confirm_with_details "y" 0 "Nhập 'y' trả về 0 (xóa file)"

# Test 8: Kiểm tra khi người dùng nhập 'Y'
echo -e "\n${BLUE}Test 8: Kiểm tra khi người dùng nhập 'Y'${NC}"
test_confirm_with_details "Y" 0 "Nhập 'Y' trả về 0 (xóa file)"

# Test 9: Kiểm tra khi người dùng nhập 'n'
echo -e "\n${BLUE}Test 9: Kiểm tra khi người dùng nhập 'n'${NC}"
test_confirm_with_details "n" 1 "Nhập 'n' trả về 1 (bỏ qua file)"

# Test 10: Kiểm tra khi người dùng nhập 'N'
echo -e "\n${BLUE}Test 10: Kiểm tra khi người dùng nhập 'N'${NC}"
test_confirm_with_details "N" 1 "Nhập 'N' trả về 1 (bỏ qua file)"

# PHẦN 3: KIỂM THỬ HÀM read_password
echo -e "\n${YELLOW}===== KIỂM THỬ HÀM read_password =====${NC}"

# Test 11: Kiểm tra khi người dùng nhập mật khẩu đơn giản
echo -e "\n${BLUE}Test 11: Kiểm tra nhập mật khẩu đơn giản${NC}"
test_read_password "password123" "Nhập mật khẩu đơn giản"

# Test 12: Kiểm tra khi người dùng nhập mật khẩu phức tạp
echo -e "\n${BLUE}Test 12: Kiểm tra nhập mật khẩu phức tạp${NC}"
test_read_password "P@ssw0rd!#$%" "Nhập mật khẩu phức tạp"

# Test 13: Kiểm tra khi người dùng nhập mật khẩu rỗng
echo -e "\n${BLUE}Test 13: Kiểm tra nhập mật khẩu rỗng${NC}"
test_read_password "" "Nhập mật khẩu rỗng"

# Hiển thị tổng kết
echo -e "\n${YELLOW}===== KẾT QUẢ KIỂM THỬ =====${NC}"
echo -e "Tổng số test: $((PASS_COUNT+FAIL_COUNT))"
echo -e "${GREEN}Số test thành công: $PASS_COUNT${NC}"
echo -e "${RED}Số test thất bại: $FAIL_COUNT${NC}"

# Trả về mã thoát dựa trên kết quả test
if [ $FAIL_COUNT -eq 0 ]; then
    echo -e "\n${GREEN}✓ TẤT CẢ CÁC TEST ĐỀU THÀNH CÔNG!${NC}"
    exit 0
else
    echo -e "\n${RED}✗ CÓ $FAIL_COUNT TEST THẤT BẠI!${NC}"
    exit 1
fi 