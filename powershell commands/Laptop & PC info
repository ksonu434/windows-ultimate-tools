& {
    Clear-Host
    Write-Host "=========================================================" -ForegroundColor Green
    Write-Host "       ULTIMATE MASTER REPORT (FIXED BATTERY)            " -ForegroundColor Black -BackgroundColor Green
    Write-Host "=========================================================" -ForegroundColor Green
    
    Write-Host "`n[1.] SYSTEM & OEM INFO:" -ForegroundColor Cyan
    Get-CimInstance Win32_ComputerSystemProduct | Select-Object Vendor, Name | Format-Table -AutoSize
    Get-CimInstance Win32_ComputerSystem | Select-Object Model, Manufacturer, SystemType | Format-Table -AutoSize
    
    Write-Host "[2.] BIOS & SERIAL NUMBER:" -ForegroundColor Cyan
    Get-CimInstance Win32_Bios | Select-Object SerialNumber | Format-Table -AutoSize
    
    Write-Host "[3.] MOTHERBOARD RAM CAPACITY:" -ForegroundColor Cyan
    Get-CimInstance Win32_PhysicalMemoryArray | Select-Object MaxCapacity, MemoryDevices | Format-Table -AutoSize
    
    Write-Host "[4.] RAM STICKS & SLOTS DETAILS:" -ForegroundColor Cyan
    Get-CimInstance Win32_PhysicalMemory | Select-Object Speed, Manufacturer, @{N="Capacity(GB)";E={[math]::round($_.Capacity/1GB, 2)}}, DeviceLocator, BankLabel, PartNumber | Format-Table -AutoSize
    
    Write-Host "[5.] STORAGE DRIVE (SSD/HDD) STATUS:" -ForegroundColor Cyan
    Get-CimInstance Win32_DiskDrive | Select-Object Model, @{N="Size(GB)";E={[math]::round($_.Size/1GB, 2)}}, Status | Format-Table -AutoSize
    
    Write-Host "[6.] CPU / PROCESSOR DETAILS:" -ForegroundColor Cyan
    Get-CimInstance Win32_Processor | Select-Object Name, Caption, DeviceID, NumberOfCores, NumberOfLogicalProcessors, MaxClockSpeed, Status | Format-Table -AutoSize

    Write-Host "[7.] GRAPHICS CARD (GPU) DETAILS:" -ForegroundColor Cyan
    Get-CimInstance Win32_VideoController | Select-Object Name, DriverVersion, @{N="Status";E={if ($_.Status) {$_.Status} else {"OK"}}} | Format-Table -AutoSize
    
    Write-Host "[8.] BATTERY HEALTH STATUS:" -ForegroundColor Cyan
    # --- SMART BATTERY DETECTION LOGIC ---
    $found = $false
    # Method 1: Try getting Win32_Battery (Standard)
    $winBat = Get-CimInstance Win32_Battery -ErrorAction SilentlyContinue
    
    if ($winBat) {
        $found = $true
        # Try finding Health info via WMI (Method A)
        $battFull = Get-CimInstance -Namespace root\WMI -ClassName BatteryFullChargedCapacity -ErrorAction SilentlyContinue
        $battStatic = Get-CimInstance -Namespace root\WMI -ClassName BatteryStaticData -ErrorAction SilentlyContinue
        
        if ($battFull -and $battStatic) {
            $design = $battStatic.DesignedCapacity
            $current = $battFull.FullChargedCapacity
            $health = [math]::Round(($current / $design) * 100, 2)
            Write-Host "  Battery Detected: Yes (via WMI)"
            Write-Host "  Designed Capacity: $design mWh"
            Write-Host "  Current Capacity:  $current mWh"
            Write-Host -NoNewline "  Health Percentage: "
            if ($health -gt 100) { $health = 100 }
            if ($health -ge 80) { Write-Host "$health %" -ForegroundColor Green } elseif ($health -ge 50) { Write-Host "$health %" -ForegroundColor Yellow } else { Write-Host "$health %" -ForegroundColor Red }
        } else {
            # Method B: Fallback to PowerCfg (The Nuclear Option)
            try {
                $tempXML = "$env:TEMP\batt_temp.xml"
                powercfg /batteryreport /xml /output $tempXML | Out-Null
                [xml]$xml = Get-Content $tempXML
                Remove-Item $tempXML -ErrorAction SilentlyContinue
                
                $design = $xml.BatteryReport.Batteries.Battery.DesignCapacity
                $current = $xml.BatteryReport.Batteries.Battery.FullChargeCapacity
                
                if ($design -and $current) {
                    $health = [math]::Round(($current / $design) * 100, 2)
                    Write-Host "  Battery Detected: Yes (via PowerCfg)"
                    Write-Host "  Designed Capacity: $design mWh"
                    Write-Host "  Current Capacity:  $current mWh"
                    Write-Host -NoNewline "  Health Percentage: "
                    if ($health -gt 100) { $health = 100 }
                    if ($health -ge 80) { Write-Host "$health %" -ForegroundColor Green } elseif ($health -ge 50) { Write-Host "$health %" -ForegroundColor Yellow } else { Write-Host "$health %" -ForegroundColor Red }
                } else {
                     Write-Host "  Battery Detected but Health Data Unavailable." -ForegroundColor Yellow
                }
            } catch {
                Write-Host "  Battery Detected but Access Restricted." -ForegroundColor Yellow
            }
        }
        Write-Host "  Charging Status: $(if ($winBat.BatteryStatus -eq 2) {'Connected / Charging'} else {'Discharging / On Battery'})`n"
    } else {
        Write-Host "  No Battery Detected (Desktop PC or Driver Issue).`n" -ForegroundColor Red
    }
    # -------------------------------------

    Write-Host "[9.] NETWORK INTERFACE (MAC ADDRESSES):" -ForegroundColor Cyan
    Get-CimInstance Win32_NetworkAdapter | Where-Object { $_.MacAddress } | Select-Object Name, MACAddress | Format-Table -AutoSize

    Write-Host "[10.] FULL SYSTEMINFO REPORT:" -ForegroundColor Cyan
    Write-Host "---------------------------------------------------------" -ForegroundColor Green
    systeminfo
    Write-Host "---------------------------------------------------------" -ForegroundColor Green
    
    Write-Host "=========================================================" -ForegroundColor Green
}
