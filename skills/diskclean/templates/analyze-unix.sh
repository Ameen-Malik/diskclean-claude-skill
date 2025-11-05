#!/bin/bash
# macOS/Linux Disk Space Analysis Script Template
# Used by diskclean skill for comprehensive space analysis

TARGET_PATH="${1:-.}"
DEPTH_LIMIT="${2:-1}"

echo "═══════════════════════════════════════════════════════"
echo "ANALYZING: $TARGET_PATH"
echo "═══════════════════════════════════════════════════════"

# Get disk info if analyzing a mount point
if df "$TARGET_PATH" >/dev/null 2>&1; then
    echo ""
    echo "Drive Status:"
    df -h "$TARGET_PATH" | tail -1 | awk '{
        total=$2; used=$3; free=$4; percent=$5
        print "├─ Total: " total
        print "├─ Used: " used
        print "└─ Free: " free " (" percent ")"
    }'

    # Check if critically low
    FREE_PERCENT=$(df "$TARGET_PATH" | tail -1 | awk '{print $5}' | sed 's/%//')
    if [ "$FREE_PERCENT" -gt 90 ]; then
        echo ""
        echo "⚠️  WARNING: Disk space critically low!"
    fi
fi

echo ""
echo ""
echo "Analyzing directories..."
echo "───────────────────────────────────────────────────────"
echo "TOP SPACE CONSUMERS"
echo "───────────────────────────────────────────────────────"

# Find top directories by size
du -h -d "$DEPTH_LIMIT" "$TARGET_PATH" 2>/dev/null | \
    grep -v '/\.' | \
    sort -hr | \
    head -15

echo ""
echo "✓ Analysis complete"
