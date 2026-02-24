#!/bin/bash

# Module: Clean Cache Files
# Xóa các cache files từ các ứng dụng và tools

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/utils.sh"

clean_cache() {
    echo ""
    echo "${BLUE}📦 Đang dọn dẹp cache files...${NC}"
    
    # Clean JetBrains cache
    safe_delete "$HOME/Library/Caches/JetBrains" "Cache JetBrains"
    
    # Clean Homebrew cache
    if command -v brew &> /dev/null; then
        brew cleanup --prune=all 2>/dev/null && show_success "Đã xóa cache Homebrew" || show_error "Lỗi khi xóa cache Homebrew"
    else
        show_info "Homebrew không được cài đặt"
    fi
    
    # Clean pip cache
    if command -v pip &> /dev/null; then
        pip cache purge 2>/dev/null && show_success "Đã xóa cache pip" || show_error "Lỗi khi xóa cache pip"
    else
        show_info "pip không được cài đặt"
    fi
    
    # Clean Cypress cache
    safe_delete "$HOME/Library/Caches/Cypress" "Cache Cypress"
    
    # Clean Playwright cache
    safe_delete "$HOME/Library/Caches/ms-playwright" "Cache Playwright"
    
    # Clean Poetry cache
    safe_delete "$HOME/Library/Caches/pypoetry" "Cache Poetry"
    
    # Clean Google cache
    safe_delete "$HOME/Library/Caches/Google" "Cache Google"
    
    # Clean CocoaPods cache
    safe_delete "$HOME/Library/Caches/CocoaPods" "Cache CocoaPods"
    
    # Clean TypeScript cache
    safe_delete "$HOME/Library/Caches/typescript" "Cache TypeScript"
    
    # Clean node-gyp cache
    safe_delete "$HOME/Library/Caches/node-gyp" "Cache node-gyp"
    
    echo "${GREEN}✓ Hoàn tất dọn dẹp cache files${NC}"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    clean_cache
fi
