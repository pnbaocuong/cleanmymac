# 🧹 Clean My PC - Script Dọn Dẹp Máy Mac

Script tự động dọn dẹp các file rác và cache trên máy Mac để giải phóng dung lượng đĩa.

## 📋 Chức năng

Script sẽ thực hiện các việc sau:

### 1. Xóa Cache Files
- ✅ Cache JetBrains (IDE cache)
- ✅ Cache Homebrew (package manager)
- ✅ Cache pip (Python package manager)
- ✅ Cache Cypress (testing framework)
- ✅ Cache Playwright (browser automation)
- ✅ Cache Poetry (Python dependency manager)
- ✅ Cache Google (browser cache)
- ✅ Cache CocoaPods, TypeScript, node-gyp

### 2. Xóa Build Artifacts
Tìm và xóa trong thư mục `Downloads` và `Documents`:
- ✅ `dist` folders
- ✅ `build` folders
- ✅ `.next` folders (Next.js)
- ✅ `target` folders (Rust/Java)
- ✅ `.venv` folders (Python virtual environments)
- ✅ `.pytest_cache` folders
- ✅ `.DS_Store` files (macOS system files)

### 3. Xóa Log Files
- ✅ Logs cũ hơn 30 ngày trong `~/Library/Logs`

### 4. Dọn Dẹp iOS Simulator
- ✅ Xóa unavailable simulator devices
- ✅ Kiểm tra và báo cáo iOS Simulator runtimes (giữ lại để tránh ảnh hưởng project)
- ✅ Kiểm tra CoreSimulator data size
- ✅ Kiểm tra disk images đang mount
- ✅ Xóa Xcode DerivedData

## 🚀 Cách sử dụng

### Cách 1: Sử dụng lệnh `cleanmypc` (Khuyến nghị)

Sau khi cài đặt, chỉ cần mở terminal và gõ:

```bash
cleanmypc
```

### Cách 2: Chạy trực tiếp script

```bash
/Users/cuongpham/Downloads/cleanmymac/cleanmypc.sh
```

### Cách 3: Chạy từng module riêng lẻ

Bạn có thể chạy từng module riêng để test hoặc debug:

```bash
# Chạy module dọn dẹp cache
source /Users/cuongpham/Downloads/cleanmymac/modules/clean_cache.sh
clean_cache

# Chạy module dọn dẹp build artifacts
source /Users/cuongpham/Downloads/cleanmymac/modules/clean_build_artifacts.sh
clean_build_artifacts

# Chạy module dọn dẹp logs
source /Users/cuongpham/Downloads/cleanmymac/modules/clean_logs.sh
clean_logs

# Chạy module dọn dẹp iOS Simulator
source /Users/cuongpham/Downloads/cleanmymac/modules/clean_ios_simulator.sh
clean_ios_simulator

# Chạy module dọn dẹp Xcode
source /Users/cuongpham/Downloads/cleanmymac/modules/clean_xcode.sh
clean_xcode
```

## 📊 Progress Indicator

Script có thanh tiến trình hiển thị % hoàn thành để bạn biết hệ thống đang hoạt động:

```
[██████████████████████████████████████████████████] 100% - Hoàn tất!
```

## ⚠️ Lưu ý

1. **Cache files sẽ tự động tạo lại** khi bạn sử dụng các ứng dụng tương ứng
2. **Build artifacts có thể tái tạo** bằng lệnh build của project
3. **Virtual environments (.venv)** có thể tái tạo bằng `python -m venv .venv`
4. **Node modules** không bị xóa - chỉ xóa build artifacts
5. **iOS Simulator runtimes và devices được giữ lại** trong script chính để tránh ảnh hưởng đến project đang phát triển
6. **Để xóa iOS Simulator runtimes cũ**, sử dụng lệnh `xcrun simctl runtime delete <runtime-id>`

## 🔧 Cài đặt

Script đã được cài đặt tự động:
- ✅ File script: `/Users/cuongpham/Downloads/cleanmymac/cleanmypc.sh`
- ✅ Alias đã được thêm vào `~/.zshrc`
- ✅ Quyền thực thi đã được cấp

Nếu lệnh `cleanmypc` không hoạt động, chạy:

```bash
source ~/.zshrc
```

## 📝 Logs

Script sẽ hiển thị:
- ✓ Các file/folder đã xóa thành công
- ✗ Các file/folder không thể xóa (nếu có)
- - Các file/folder không tồn tại

## 🎯 Kết quả mong đợi

Sau khi chạy script, bạn có thể giải phóng:
- **Cache files**: ~29GB
- **Build artifacts**: Tùy theo project
- **Log files**: ~466MB
- **iOS Simulator runtimes** (nếu xóa thủ công): ~23.5GB (3 runtimes)
- **CoreSimulator data** (nếu xóa thủ công): ~6.6GB

**Tổng cộng có thể giải phóng: ~30GB+ (hoặc ~60GB+ nếu xóa iOS Simulator)**

## 🍎 iOS Simulator Cleanup

Script chính (`cleanmypc`) **KHÔNG tự động xóa** iOS Simulator runtimes và devices để tránh ảnh hưởng đến project. Thay vào đó, nó sẽ:
- Báo cáo số lượng runtimes và devices
- Hiển thị kích thước CoreSimulator data
- Đưa ra hướng dẫn để xóa thủ công nếu cần

**Để xóa iOS Simulator runtimes cũ:**

Xóa thủ công bằng lệnh:
   ```bash
   # Xem danh sách runtimes
   xcrun simctl runtime list
   
   # Xóa runtime cụ thể
   xcrun simctl runtime delete <runtime-id>
   
   # Xóa unavailable devices
   xcrun simctl delete unavailable
   
   # Xóa tất cả device data (cẩn thận!)
   xcrun simctl erase all
   ```

**Lưu ý quan trọng:**
- Xóa runtimes có thể ảnh hưởng đến project đang phát triển
- Nên giữ lại ít nhất 1-2 runtimes mới nhất
- Device data chứa apps và dữ liệu test - xóa sẽ mất hết

## 🏗️ Kiến trúc Module

Script được tổ chức theo kiến trúc module để dễ bảo trì và test:

```
cleanmymac/
├── cleanmypc.sh                    # Script chính (orchestrator)
└── modules/
    ├── utils.sh                     # Utilities chung (colors, helpers)
    ├── clean_cache.sh               # Module dọn dẹp cache
    ├── clean_build_artifacts.sh     # Module dọn dẹp build artifacts
    ├── clean_logs.sh                # Module dọn dẹp logs
    ├── clean_ios_simulator.sh       # Module dọn dẹp iOS Simulator
    └── clean_xcode.sh               # Module dọn dẹp Xcode data
```

**Lợi ích:**
- ✅ Code gọn gàng, không duplicate
- ✅ Dễ test từng module riêng lẻ
- ✅ Dễ bảo trì và mở rộng
- ✅ Mỗi module có thể chạy độc lập

## 🔄 Cập nhật

### Cập nhật script chính:
```bash
/Users/cuongpham/Downloads/cleanmymac/cleanmypc.sh
```

### Cập nhật module cụ thể:
```bash
/Users/cuongpham/Downloads/cleanmymac/modules/<module_name>.sh
```

### Thêm module mới:
1. Tạo file mới trong `modules/`
2. Source `utils.sh` để dùng common functions
3. Tạo function chính với tên module (ví dụ: `clean_new_feature()`)
4. Thêm case vào `cleanmypc.sh` trong function `run_module()`

---

**Tác giả**: Auto-generated  
**Ngày tạo**: 2025-01-28
