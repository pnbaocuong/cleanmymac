#!/bin/bash

# Module: Clean Log Files
# Xóa logs cũ hơn 30 ngày

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/utils.sh"

clean_logs() {
    echo ""
    echo "${BLUE}📋 Đang dọn dẹp log files...${NC}"
    
    local days_old=30
    OLD_LOGS=$(find "$HOME/Library/Logs" -type f -mtime +${days_old} 2>/dev/null | wc -l | tr -d ' ')
    
    if [ "$OLD_LOGS" -gt 0 ]; then
        find "$HOME/Library/Logs" -type f -mtime +${days_old} -delete 2>/dev/null
        show_success "Đã xóa ${OLD_LOGS} file log cũ hơn ${days_old} ngày"
    else
        show_info "Không có log cũ hơn ${days_old} ngày để xóa"
    fi
    
    echo "${GREEN}✓ Hoàn tất dọn dẹp log files${NC}"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    clean_logs
fi
