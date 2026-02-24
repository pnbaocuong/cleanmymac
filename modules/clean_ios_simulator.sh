#!/bin/bash

# Module: Clean iOS Simulator
# Dọn dẹp iOS Simulator devices, runtimes, và data

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/utils.sh"

clean_ios_simulator() {
    echo ""
    echo "${BLUE}🍎 Đang dọn dẹp iOS Simulator...${NC}"
    
    if ! command -v xcrun &> /dev/null; then
        show_info "Xcode Command Line Tools không được cài đặt"
        echo "${GREEN}✓ Hoàn tất dọn dẹp iOS Simulator${NC}"
        return
    fi
    
    # Step 1: Delete unavailable devices
    UNAVAILABLE_OUTPUT=$(xcrun simctl delete unavailable 2>&1)
    if [ $? -eq 0 ] && [ -n "$UNAVAILABLE_OUTPUT" ]; then
        UNAVAILABLE_COUNT=$(echo "$UNAVAILABLE_OUTPUT" | grep -c "deleted" || echo "0")
        if [ "$UNAVAILABLE_COUNT" -gt 0 ]; then
            show_success "Đã xóa các simulator devices không khả dụng"
        else
            show_info "Không có simulator devices không khả dụng"
        fi
    else
        show_info "Không có simulator devices không khả dụng"
    fi
    
    # Step 2: Report shutdown devices
    SHUTDOWN_DEVICES=$(xcrun simctl list devices 2>/dev/null | grep -c "(Shutdown)" || echo "0")
    if [ "$SHUTDOWN_DEVICES" -gt 0 ]; then
        show_info "Có ${SHUTDOWN_DEVICES} devices đang shutdown (giữ lại để tránh mất dữ liệu)"
    fi
    
    # Step 3: Report runtimes
    RUNTIMES=$(xcrun simctl runtime list 2>/dev/null | grep "iOS" | grep "Ready" | wc -l | tr -d ' ')
    if [ "$RUNTIMES" -gt 1 ]; then
        show_info "Có ${RUNTIMES} iOS runtimes (giữ lại tất cả để tránh ảnh hưởng đến project)"
        show_tip "Để xóa runtimes cũ, chạy: xcrun simctl runtime delete <runtime-id>"
    else
        show_info "Không có nhiều runtimes để xóa"
    fi
    
    # Step 4: Report CoreSimulator data size
    if [ -d "$HOME/Library/Developer/CoreSimulator" ]; then
        CORE_SIM_SIZE=$(get_size "$HOME/Library/Developer/CoreSimulator")
        show_info "CoreSimulator hiện tại: ${CORE_SIM_SIZE}"
        show_tip "Để xóa device data cũ, chạy: xcrun simctl erase all"
    fi
    
    # Step 5: Report mounted disk images
    MOUNTED_IMAGES=$(hdiutil info 2>/dev/null | grep "image-path" | grep -v "/System" | grep -v "/Library/Developer" | wc -l | tr -d ' ')
    if [ "$MOUNTED_IMAGES" -gt 0 ]; then
        show_info "Có ${MOUNTED_IMAGES} disk images đang mount (không phải system)"
        show_tip "Để unmount, chạy: hdiutil detach <mount-point>"
    else
        show_info "Không có disk images không cần thiết để unmount"
    fi
    
    echo "${GREEN}✓ Hoàn tất dọn dẹp iOS Simulator${NC}"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    clean_ios_simulator
fi
