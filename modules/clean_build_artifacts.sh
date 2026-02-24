#!/bin/bash

# Module: Clean Build Artifacts
# Xóa các build artifacts trong Downloads và Documents

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/utils.sh"

clean_build_artifacts() {
    echo ""
    echo "${BLUE}🔨 Đang dọn dẹp build artifacts...${NC}"
    
    # Patterns to find and delete
    PATTERNS=(
        "dist"
        "build"
        ".next"
        "target"
        ".venv"
        ".pytest_cache"
    )
    
    # Directories to search
    SEARCH_DIRS=(
        "$HOME/Downloads"
        "$HOME/Documents"
    )
    
    for dir in "${SEARCH_DIRS[@]}"; do
        if [ -d "$dir" ]; then
            echo "  📁 Đang quét thư mục $(basename "$dir")..."
            for pattern in "${PATTERNS[@]}"; do
                find "$dir" -type d -name "$pattern" -prune -exec rm -rf {} + 2>/dev/null || true
            done
            # Delete .DS_Store files
            find "$dir" -type f -name ".DS_Store" -delete 2>/dev/null || true
            show_success "Đã xóa build artifacts trong $(basename "$dir")"
        fi
    done
    
    echo "${GREEN}✓ Hoàn tất dọn dẹp build artifacts${NC}"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    clean_build_artifacts
fi
