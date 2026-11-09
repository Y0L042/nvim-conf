# Memory leak diagnostic script for Neovim (PowerShell version)
# Run this in a separate PowerShell terminal while using Neovim

Write-Host "===================================" -ForegroundColor Cyan
Write-Host "Neovim Memory Leak Monitor" -ForegroundColor Cyan
Write-Host "===================================" -ForegroundColor Cyan
Write-Host "Monitoring nvim.exe and child processes..."
Write-Host ""

# Initialize variables
$prevTotal = 0
$counter = 0

# Setup log file in Downloads
$logPath = "$env:USERPROFILE\Downloads\nvim_memory_log.txt"
$startTime = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'

# Create/clear log file and write header
"=================================== " | Out-File -FilePath $logPath -Encoding UTF8
"Neovim Memory Leak Monitor" | Out-File -FilePath $logPath -Append -Encoding UTF8
"Started: $startTime" | Out-File -FilePath $logPath -Append -Encoding UTF8
"=================================== " | Out-File -FilePath $logPath -Append -Encoding UTF8
"" | Out-File -FilePath $logPath -Append -Encoding UTF8

Write-Host "Logging to: $logPath" -ForegroundColor Yellow
Write-Host "Press Ctrl+C to stop monitoring"
Write-Host ""

# Monitor loop
while ($true) {
    # Get process memory in MB
    $nvimProcesses = Get-Process -Name nvim -ErrorAction SilentlyContinue
    $clangdProcesses = Get-Process -Name clangd -ErrorAction SilentlyContinue
    $luaLsProcesses = Get-Process -Name "lua-language-server" -ErrorAction SilentlyContinue
    
    # Calculate memory in MB
    $nvimMem = if ($nvimProcesses) { 
        ($nvimProcesses | Measure-Object -Property WorkingSet64 -Sum).Sum / 1MB 
    } else { 0 }
    
    $clangdMem = if ($clangdProcesses) { 
        ($clangdProcesses | Measure-Object -Property WorkingSet64 -Sum).Sum / 1MB 
    } else { 0 }
    
    $luaLsMem = if ($luaLsProcesses) { 
        ($luaLsProcesses | Measure-Object -Property WorkingSet64 -Sum).Sum / 1MB 
    } else { 0 }
    
    # Display timestamp
    $timestamp = Get-Date -Format 'yyyy/MM/dd HH:mm:ss'
    Write-Host $timestamp
    $timestamp | Out-File -FilePath $logPath -Append -Encoding UTF8
    
    # Display nvim memory
    if ($nvimMem -gt 0) {
        $nvimLine = "  nvim.exe: $([math]::Round($nvimMem, 1)) MB"
        Write-Host $nvimLine -ForegroundColor Green
        $nvimLine | Out-File -FilePath $logPath -Append -Encoding UTF8
    } else {
        $nvimLine = "  nvim.exe: Not running"
        Write-Host $nvimLine -ForegroundColor Gray
        $nvimLine | Out-File -FilePath $logPath -Append -Encoding UTF8
    }
    
    # Display clangd memory
    if ($clangdMem -gt 0) {
        $clangdLine = "  clangd.exe: $([math]::Round($clangdMem, 1)) MB"
        Write-Host $clangdLine -ForegroundColor Green
        $clangdLine | Out-File -FilePath $logPath -Append -Encoding UTF8
    }
    
    # Display lua-language-server memory
    if ($luaLsMem -gt 0) {
        $luaLine = "  lua-language-server.exe: $([math]::Round($luaLsMem, 1)) MB"
        Write-Host $luaLine -ForegroundColor Green
        $luaLine | Out-File -FilePath $logPath -Append -Encoding UTF8
    }
    
    # Calculate total
    $total = $nvimMem + $clangdMem + $luaLsMem
    
    if ($total -gt 0) {
        $totalLine = "  TOTAL: $([math]::Round($total, 1)) MB"
        Write-Host $totalLine -ForegroundColor Yellow
        $totalLine | Out-File -FilePath $logPath -Append -Encoding UTF8
        
        # Warning if over 1GB
        if ($total -gt 1024) {
            $warnLine = "  ** WARNING: Memory usage over 1GB! **"
            Write-Host $warnLine -ForegroundColor Red
            $warnLine | Out-File -FilePath $logPath -Append -Encoding UTF8
        }
        
        # Critical if over 5GB
        if ($total -gt 5120) {
            $critLine = "  *** CRITICAL: Memory usage over 5GB! ***"
            Write-Host $critLine -ForegroundColor Red
            $critLine | Out-File -FilePath $logPath -Append -Encoding UTF8
        }
        
        # Show growth rate
        if ($prevTotal -gt 0) {
            $growth = $total - $prevTotal
            if ($growth -ne 0) {
                if ($growth -gt 0) {
                    $growthLine = "  Growth: +$([math]::Round($growth, 1)) MB"
                    Write-Host $growthLine -ForegroundColor Red
                    $growthLine | Out-File -FilePath $logPath -Append -Encoding UTF8
                } else {
                    $growthLine = "  Decreased: $([math]::Round([math]::Abs($growth), 1)) MB"
                    Write-Host $growthLine -ForegroundColor Green
                    $growthLine | Out-File -FilePath $logPath -Append -Encoding UTF8
                }
            }
        }
    }
    
    # Update previous total
    $prevTotal = $total
    Write-Host ""
    "" | Out-File -FilePath $logPath -Append -Encoding UTF8
    
    # Increment counter
    $counter++
    
    # Every 10 iterations (5 minutes), show a summary
    if ($counter % 10 -eq 0) {
        $summaryLines = @(
            "=========================================="
            "--- 5 Minute Mark ($($counter / 2) minutes total) ---"
            "If memory is growing steadily, you have a leak."
            "In nvim run: :MemCheck :LspLogCheck :CacheCheck"
            "=========================================="
        )
        
        foreach ($line in $summaryLines) {
            Write-Host $line -ForegroundColor Cyan
            $line | Out-File -FilePath $logPath -Append -Encoding UTF8
        }
        
        Write-Host ""
        "" | Out-File -FilePath $logPath -Append -Encoding UTF8
    }
    
    # Wait 30 seconds
    Start-Sleep -Seconds 30
}
