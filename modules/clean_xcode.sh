#!/bin/bash

# Module: Clean Xcode Data
# Xóa Xcode DerivedData và báo cáo Archives

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/utils.sh"

clean_xcode() {
    echo ""
    echo "${BLUE}🛠️  Đang dọn dẹp Xcode data...${NC}"
    
    # Clean Xcode DerivedData
    safe_delete "$HOME/Library/Developer/Xcode/DerivedData" "Xcode DerivedData"
    
    # Report Xcode Archives size (don't delete automatically)
    if [ -d "$HOME/Library/Developer/Xcode/Archives" ]; then
        ARCHIVE_SIZE=$(get_size "$HOME/Library/Developer/Xcode/Archives")
        show_info "Xcode Archives: ${ARCHIVE_SIZE} (giữ lại để tránh mất dữ liệu)"
        show_tip "Để xóa archives cũ, xóa thủ công trong Xcode > Window > Organizer"
    fi
    
    echo "${GREEN}✓ Hoàn tất dọn dẹp Xcode data${NC}"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    clean_xcode
fi
