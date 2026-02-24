#!/bin/bash

# Common utilities for cleanmypc modules
# Source this file in other scripts: source "$(dirname "$0")/utils.sh"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to calculate size before deletion
get_size() {
    if [ -d "$1" ] || [ -f "$1" ]; then
        du -sh "$1" 2>/dev/null | awk '{print $1}' || echo "0"
    else
        echo "0"
    fi
}

# Function to delete with size reporting
safe_delete() {
    local path="$1"
    local name="$2"
    if [ -e "$path" ]; then
        local size=$(get_size "$path")
        rm -rf "$path" 2>/dev/null && echo "  ✓ Đã xóa ${name}: ${size}" || echo "  ✗ Không thể xóa ${name}"
    else
        echo "  - ${name}: Không tồn tại"
    fi
}

# Function to show info message
show_info() {
    echo "  ℹ ${1}"
}

# Function to show tip message
show_tip() {
    echo "  💡 ${1}"
}

# Function to show success message
show_success() {
    echo "  ✓ ${1}"
}

# Function to show error message
show_error() {
    echo "  ✗ ${1}"
}
