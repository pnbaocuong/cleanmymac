#!/bin/bash

# Script dọn dẹp máy Mac - Clean My PC
# Tác giả: Auto-generated
# Ngày tạo: $(date +"%Y-%m-%d")

set -e

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODULES_DIR="${SCRIPT_DIR}/modules"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Progress tracking
TOTAL_STEPS=5
CURRENT_STEP=0

# Function to show progress
show_progress() {
    CURRENT_STEP=$((CURRENT_STEP + 1))
    PERCENT=$((CURRENT_STEP * 100 / TOTAL_STEPS))
    BAR_LENGTH=50
    FILLED=$((PERCENT * BAR_LENGTH / 100))
    BAR=""
    for ((i=0; i<FILLED; i++)); do
        BAR="${BAR}█"
    done
    for ((i=FILLED; i<BAR_LENGTH; i++)); do
        BAR="${BAR}░"
    done
    printf "\r${BLUE}[${BAR}] ${PERCENT}%% - ${1}${NC}"
}

# Function to run module
run_module() {
    local module_name="$1"
    local display_name="$2"
    local module_script="${MODULES_DIR}/${module_name}"
    
    if [ ! -f "$module_script" ]; then
        echo "  ✗ Module không tồn tại: ${module_name}"
        return 1
    fi
    
    show_progress "${display_name}..."
    source "$module_script"
    
    # Call the main function based on module name
    case "$module_name" in
        clean_cache.sh)
            clean_cache
            ;;
        clean_build_artifacts.sh)
            clean_build_artifacts
            ;;
        clean_logs.sh)
            clean_logs
            ;;
        clean_ios_simulator.sh)
            clean_ios_simulator
            ;;
        clean_xcode.sh)
            clean_xcode
            ;;
        *)
            echo "  ✗ Module không được hỗ trợ: ${module_name}"
            return 1
            ;;
    esac
    echo ""
}

echo ""
echo "${GREEN}╔══════════════════════════════════════════════════════════╗${NC}"
echo "${GREEN}║         🧹 CLEAN MY PC - DỌN DẸP MÁY MAC 🧹            ║${NC}"
echo "${GREEN}╚══════════════════════════════════════════════════════════╝${NC}"
echo ""

# Start cleaning
echo "${YELLOW}Bắt đầu quá trình dọn dẹp...${NC}"
echo ""

# Step 1: Clean cache files
run_module "clean_cache.sh" "Đang dọn dẹp cache files"

# Step 2: Clean build artifacts
run_module "clean_build_artifacts.sh" "Đang dọn dẹp build artifacts"

# Step 3: Clean logs
run_module "clean_logs.sh" "Đang dọn dẹp log files"

# Step 4: Clean iOS Simulator
run_module "clean_ios_simulator.sh" "Đang dọn dẹp iOS Simulator"

# Step 5: Clean Xcode data
run_module "clean_xcode.sh" "Đang dọn dẹp Xcode data"

# Complete
show_progress "Hoàn tất!"
echo ""
echo ""

# Show summary
echo "${GREEN}╔══════════════════════════════════════════════════════════╗${NC}"
echo "${GREEN}║              ✅ DỌN DẸP HOÀN TẤT! ✅                    ║${NC}"
echo "${GREEN}╚══════════════════════════════════════════════════════════╝${NC}"
echo ""
echo "${YELLOW}Đã thực hiện:${NC}"
echo "  ✓ Xóa cache files (JetBrains, Homebrew, pip, Cypress, Playwright, Poetry, Google, CocoaPods, TypeScript, node-gyp)"
echo "  ✓ Xóa build artifacts (dist, build, .next, target, .venv, .pytest_cache, .DS_Store)"
echo "  ✓ Xóa logs cũ hơn 30 ngày"
echo "  ✓ Dọn dẹp iOS Simulator (devices, runtimes, CoreSimulator data, disk images)"
echo "  ✓ Dọn dẹp Xcode data (DerivedData)"
echo ""
echo "${GREEN}Máy Mac của bạn đã được dọn dẹp! 🎉${NC}"
echo ""
echo "${YELLOW}💡 Lưu ý:${NC}"
echo "  - iOS Simulator runtimes và devices được giữ lại để tránh ảnh hưởng đến project"
echo "  - Để xóa runtimes cũ: xcrun simctl runtime delete <runtime-id>"
echo "  - Để xóa tất cả device data: xcrun simctl erase all"
echo "  - Để xóa archives cũ: Xcode > Window > Organizer"
echo ""
