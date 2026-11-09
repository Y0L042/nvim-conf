#!/bin/bash
# Memory leak diagnostic script for Neovim
# Run this in a separate terminal while using Neovim

echo "==================================="
echo "Neovim Memory Leak Monitor"
echo "==================================="
echo "Monitoring nvim.exe and child processes..."
echo ""

# Initialize global variable
prev_total=0

# Function to get process memory (Windows-compatible)
get_memory() {
    # Use local variables for process memories
    local nvim_mem clangd_mem lua_ls_mem total total_mb growth growth_mb nvim_mb clangd_mb lua_mb
    
    # Get memory values - simpler parsing approach
    # tasklist output format: "name","pid","session","session#","memory"
    # Memory format varies by locale: "86.388 K" or "8 516 K" (with space as thousands separator)
    # Strip quotes, spaces, 'K', and any separators to get the raw KB value
    nvim_mem=$(tasklist //FI "IMAGENAME eq nvim.exe" //FO CSV //NH 2>/dev/null | \
        awk -F',' '{gsub(/[ "K.]/,"",$5); sum+=$5} END {print sum+0}')
    
    clangd_mem=$(tasklist //FI "IMAGENAME eq clangd.exe" //FO CSV //NH 2>/dev/null | \
        awk -F',' '{gsub(/[ "K.]/,"",$5); sum+=$5} END {print sum+0}')
    
    lua_ls_mem=$(tasklist //FI "IMAGENAME eq lua-language-server.exe" //FO CSV //NH 2>/dev/null | \
        awk -F',' '{gsub(/[ "K.]/,"",$5); sum+=$5} END {print sum+0}')
    
    # Ensure they're valid numbers (awk already returns 0 if empty)
    nvim_mem=${nvim_mem:-0}
    clangd_mem=${clangd_mem:-0}
    lua_ls_mem=${lua_ls_mem:-0}
    
    echo "$(date '+%Y-%m-%d %H:%M:%S')"
    
    # Display nvim memory
    if [ $nvim_mem -gt 0 ]; then
        nvim_mb=$((nvim_mem / 1024))
        echo "  nvim.exe: ${nvim_mb} MB (${nvim_mem} KB)"
    else
        echo "  nvim.exe: Not running"
    fi
    
    # Display clangd memory
    if [ $clangd_mem -gt 0 ]; then
        clangd_mb=$((clangd_mem / 1024))
        echo "  clangd.exe: ${clangd_mb} MB (${clangd_mem} KB)"
    fi
    
    # Display lua-ls memory
    if [ $lua_ls_mem -gt 0 ]; then
        lua_mb=$((lua_ls_mem / 1024))
        echo "  lua-language-server.exe: ${lua_mb} MB (${lua_ls_mem} KB)"
    fi
    
    # Calculate total
    total=$((nvim_mem + clangd_mem + lua_ls_mem))
    
    if [ $total -gt 0 ]; then
        total_mb=$((total / 1024))
        echo "  TOTAL: ${total_mb} MB (${total} KB)"
        
        # Warning if over 1GB (1048576 KB)
        if [ $total -gt 1048576 ]; then
            echo "  ** WARNING: Memory usage over 1GB! **"
        fi
        
        # Critical if over 5GB (5242880 KB)
        if [ $total -gt 5242880 ]; then
            echo "  *** CRITICAL: Memory usage over 5GB! ***"
        fi
        
        # Show growth rate if we have previous measurement
        if [ $prev_total -gt 0 ]; then
            growth=$((total - prev_total))
            if [ $growth -ne 0 ]; then
                growth_mb=$((growth / 1024))
                if [ $growth -gt 0 ]; then
                    echo "  Growth: +${growth_mb} MB (+${growth} KB)"
                else
                    echo "  Decreased: ${growth_mb} MB (${growth} KB)"
                fi
            fi
        fi
    fi
    
    # Update the global prev_total for next iteration
    prev_total=$total
    echo ""
}

# Monitor every 30 seconds
counter=0
echo "Press Ctrl+C to stop monitoring"
echo ""

while true; do
    get_memory
    counter=$((counter + 1))
    
    # Every 10 iterations (5 minutes), show a summary
    if [ $((counter % 10)) -eq 0 ]; then
        echo "=========================================="
        echo "--- 5 Minute Mark ($(($counter / 2)) minutes total) ---"
        echo "If memory is growing steadily, you have a leak."
        echo "In nvim run: :MemCheck :LspLogCheck :CacheCheck"
        echo "=========================================="
        echo ""
    fi
    
    sleep 30
done