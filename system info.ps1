Get-CimInstance Win32_ComputerSystemProduct | Select-Object Vendor, Name

Get-CimInstance Win32_Bios | Select-Object SerialNumber

Get-CimInstance Win32_PhysicalMemoryArray | Select-Object MaxCapacity, MemoryDevices

Get-CimInstance Win32_PhysicalMemory | Select-Object Speed, Manufacturer, @{N="Capacity(GB)";E={[math]::round($_.Capacity/1GB, 2)}}, PartNumber

Get-CimInstance Win32_DiskDrive | Select-Object Model, @{N="Size(GB)";E={[math]::round($_.Size/1GB, 2)}}, Status

Get-CimInstance Win32_Processor | Select-Object Name, NumberOfCores, NumberOfLogicalProcessors, MaxClockSpeed

systeminfo
