@echo off
REM Memory leak diagnostic script for Neovim (Windows Batch version)
REM Run this in a separate terminal while using Neovim

setlocal enabledelayedexpansion

echo ===================================
echo Neovim Memory Leak Monitor
echo ===================================
echo Monitoring nvim.exe and child processes...
echo.

REM Initialize counter and previous total
set counter=0
set prev_total=0

echo Press Ctrl+C to stop monitoring
echo.

:monitor_loop
    call :get_memory
    set /a counter+=1
    
    REM Every 10 iterations (5 minutes), show a summary
    set /a mod=counter %% 10
    if !mod! equ 0 (
        echo ==========================================
        set /a minutes=counter / 2
        echo --- 5 Minute Mark ^(!minutes! minutes total^) ---
        echo If memory is growing steadily, you have a leak.
        echo In nvim run: :MemCheck :LspLogCheck :CacheCheck
        echo ==========================================
        echo.
    )
    
    REM Wait 30 seconds
    timeout /t 30 /nobreak > nul
    goto monitor_loop

:get_memory
    REM Get memory for each process type
    set nvim_mem=0
    set clangd_mem=0
    set lua_ls_mem=0
    
    REM Sum nvim.exe memory
    for /f "tokens=5 delims=," %%x in ('tasklist /fo csv /nh /fi "imagename eq nvim.exe" 2^>nul') do (
        call :parse_memory %%x nvim_mem
    )
    
    REM Sum clangd.exe memory
    for /f "tokens=5 delims=," %%x in ('tasklist /fo csv /nh /fi "imagename eq clangd.exe" 2^>nul') do (
        call :parse_memory %%x clangd_mem
    )
    
    REM Sum lua-language-server.exe memory
    for /f "tokens=5 delims=," %%x in ('tasklist /fo csv /nh /fi "imagename eq lua-language-server.exe" 2^>nul') do (
        call :parse_memory %%x lua_ls_mem
    )
    
    REM Display timestamp
    echo %date% %time:~0,8%
    
    REM Display nvim memory
    if !nvim_mem! gtr 0 (
        set /a nvim_mb=nvim_mem / 1024
        echo   nvim.exe: !nvim_mb! MB ^(!nvim_mem! KB^)
    ) else (
        echo   nvim.exe: Not running
    )
    
    REM Display clangd memory
    if !clangd_mem! gtr 0 (
        set /a clangd_mb=clangd_mem / 1024
        echo   clangd.exe: !clangd_mb! MB ^(!clangd_mem! KB^)
    )
    
    REM Display lua-ls memory
    if !lua_ls_mem! gtr 0 (
        set /a lua_mb=lua_ls_mem / 1024
        echo   lua-language-server.exe: !lua_mb! MB ^(!lua_ls_mem! KB^)
    )
    
    REM Calculate total
    set /a total=nvim_mem + clangd_mem + lua_ls_mem
    
    if !total! gtr 0 (
        set /a total_mb=total / 1024
        echo   TOTAL: !total_mb! MB ^(!total! KB^)
        
        REM Warning if over 1GB (1048576 KB)
        if !total! gtr 1048576 (
            echo   ** WARNING: Memory usage over 1GB! **
        )
        
        REM Critical if over 5GB (5242880 KB)
        if !total! gtr 5242880 (
            echo   *** CRITICAL: Memory usage over 5GB! ***
        )
        
        REM Show growth rate if we have previous measurement
        if !prev_total! gtr 0 (
            set /a growth=total - prev_total
            if !growth! neq 0 (
                set /a growth_mb=growth / 1024
                if !growth! gtr 0 (
                    echo   Growth: +!growth_mb! MB ^(+!growth! KB^)
                ) else (
                    echo   Decreased: !growth_mb! MB ^(!growth! KB^)
                )
            )
        )
    )
    
    REM Update previous total
    set prev_total=!total!
    echo.
    goto :eof

:parse_memory
    REM Parse memory value from tasklist output
    REM Input format varies by locale: "86.388 K" or "8 516 K" (with space as thousands separator)
    REM Example: "8 516 K" should become 8516
    set mem_str=%~1
    
    REM Remove quotes
    set mem_str=!mem_str:"=!
    
    REM Remove all spaces (works as loop in batch)
    :remove_spaces
    if "!mem_str!" neq "!mem_str: =!" (
        set mem_str=!mem_str: =!
        goto remove_spaces
    )
    
    REM Remove 'K' suffix
    set mem_str=!mem_str:K=!
    
    REM Remove dots/periods
    set mem_str=!mem_str:.=!
    
    REM Add to the accumulator variable (only if numeric and not empty)
    set var_name=%~2
    if defined mem_str (
        if "!mem_str!" neq "" (
            set /a !var_name!+=mem_str 2>nul
        )
    )
    goto :eof
