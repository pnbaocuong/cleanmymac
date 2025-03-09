# Clean My Mac - Công cụ làm sạch máy Mac

Đây là công cụ giúp dọn dẹp máy Mac bằng cách tìm và xóa các file tạm, cache và file rác khác. Mã nguồn được tổ chức theo mô-đun để dễ dàng mở rộng và thêm các mẫu nhận dạng mới.

## Cấu trúc thư mục

```
cleanmymac/
├── clean_my_mac.sh           # File chính gọi các module
├── utils.sh                  # Chứa các hàm tiện ích chung
├── test_utils.sh             # File kiểm thử
└── patterns/                 # Thư mục chứa các mẫu nhận dạng
    ├── downloads.sh          # Xử lý thư mục Downloads
    ├── trash.sh              # Xử lý Thùng rác
    ├── cache.sh              # Xử lý các file cache
    ├── logs.sh               # Xử lý các file log
    ├── temp_files.sh         # Xử lý các file tạm thời
    ├── apps.sh               # Xử lý các ứng dụng đã tải xuống
    ├── ds_store.sh           # Xử lý các file .DS_Store
    ├── dev_tools.sh          # Xử lý các công cụ phát triển
    ├── docker.sh             # Xử lý Docker
    └── time_machine.sh       # Xử lý Time Machine
```

## Cách sử dụng

1. Cấp quyền thực thi cho script:
   ```bash
   chmod +x clean_my_mac.sh
   ```

2. Chạy script:
   ```bash
   ./clean_my_mac.sh
   ```

3. Chọn các tùy chọn dọn dẹp từ menu:
   - Dọn dẹp thư mục Downloads
   - Dọn dẹp Thùng rác
   - Dọn dẹp file cache
   - Dọn dẹp file logs
   - Dọn dẹp file tạm thời
   - Quản lý ứng dụng
   - Dọn dẹp file .DS_Store
   - Dọn dẹp công cụ phát triển (Xcode, npm, yarn)
   - Dọn dẹp Docker
   - Dọn dẹp Time Machine
   - Dọn dẹp tất cả

## Chạy kiểm thử

Để chạy kiểm thử cho các hàm tiện ích:

```bash
chmod +x test_utils.sh
./test_utils.sh
```

Kiểm thử tập trung vào hàm `confirm_with_details` để đảm bảo nó chỉ chấp nhận đúng ký tự 'y' hoặc 'Y' khi xác nhận xóa file.

## Cách thêm mẫu nhận dạng mới

1. **Tạo file mới trong thư mục `patterns/`**:
   ```bash
   touch patterns/new_pattern.sh
   ```

2. **Viết hàm xử lý mẫu nhận dạng mới**:
   ```bash
   #!/bin/bash

   # Mô-đun xử lý mẫu nhận dạng mới
   # Mô tả về mẫu nhận dạng này

   # Mức độ nghiêm trọng
   SEVERITY_LOW="${GREEN}THẤP${NC}"
   SEVERITY_MEDIUM="${YELLOW}TRUNG BÌNH${NC}"
   SEVERITY_HIGH="${RED}CAO${NC}"

   # Hàm chính để dọn dẹp mẫu nhận dạng mới
   clean_new_pattern() {
       print_message "Kiểm tra mẫu nhận dạng mới..."
       
       # Thêm mã xử lý mẫu nhận dạng mới tại đây
       # Có thể sử dụng các hàm tiện ích như:
       # - remove_with_detailed_confirmation
       # - find_and_remove
   }
   ```

3. **Thêm import mẫu nhận dạng mới vào file `clean_my_mac.sh`**:
   ```bash
   # Import mẫu nhận dạng mới
   source "$(dirname "$0")/patterns/new_pattern.sh"
   ```

4. **Thêm tùy chọn mới vào menu chính** trong file `clean_my_mac.sh`:
   ```bash
   echo "12. Dọn dẹp mẫu nhận dạng mới"
   ```

5. **Thêm xử lý cho tùy chọn mới** trong phần switch-case:
   ```bash
   12) clean_new_pattern ;;
   ```

6. **Thêm vào phần "Dọn dẹp tất cả"**:
   ```bash
   clean_new_pattern
   ```

## Lưu ý an toàn

- Luôn xem xét kỹ thông tin trước khi xóa bất kỳ file nào.
- Chỉ xóa khi bạn chắc chắn file không còn cần thiết.
- Một số tác vụ yêu cầu quyền quản trị (sudo).
- Script này sẽ yêu cầu xác nhận trước khi xóa bất kỳ file nào.
- Chỉ nhập 'y' hoặc 'Y' để xác nhận xóa, nhập bất kỳ ký tự nào khác để bỏ qua.

## Đóng góp

Nếu bạn muốn thêm các mẫu nhận dạng mới hoặc cải thiện công cụ, hãy tạo pull request! 