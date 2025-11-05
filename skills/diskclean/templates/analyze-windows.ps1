# Windows Disk Space Analysis Script Template
# Used by diskclean skill for comprehensive space analysis

param(
    [Parameter(Mandatory=$true)]
    [string]$TargetPath,

    [Parameter(Mandatory=$false)]
    [int]$DepthLimit = 1
)

Write-Host "═══════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "ANALYZING: $TargetPath" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════════" -ForegroundColor Cyan

# Function to get directory size
function Get-DirectorySize {
    param([string]$Path)

    $size = (Get-ChildItem -Path $Path -Recurse -File -ErrorAction SilentlyContinue |
             Measure-Object -Property Length -Sum).Sum

    if ($size) {
        return $size
    } else {
        return 0
    }
}

# Get drive info if analyzing a drive
if ($TargetPath -match '^[A-Z]:[\\/]?$') {
    $drive = Get-PSDrive -Name $TargetPath[0]
    $totalGB = [math]::Round(($drive.Used + $drive.Free)/1GB, 2)
    $usedGB = [math]::Round($drive.Used/1GB, 2)
    $freeGB = [math]::Round($drive.Free/1GB, 2)
    $freePercent = [math]::Round(($drive.Free / ($drive.Used + $drive.Free)) * 100, 1)

    Write-Host "`nDrive Status: $($TargetPath)" -ForegroundColor Yellow
    Write-Host "├─ Total: $totalGB GB"
    Write-Host "├─ Used: $usedGB GB"
    Write-Host "└─ Free: $freeGB GB ($freePercent%)" -ForegroundColor $(if ($freePercent -lt 10) { "Red" } else { "Green" })

    if ($freePercent -lt 10) {
        Write-Host "`n⚠️  WARNING: Disk space critically low!" -ForegroundColor Red
    }
}

# Analyze top-level directories
Write-Host "`n`nAnalyzing directories..." -ForegroundColor Cyan
$dirs = Get-ChildItem -Path $TargetPath -Directory -ErrorAction SilentlyContinue
$results = @()

foreach ($dir in $dirs) {
    # Skip system folders
    $skipFolders = @('Windows', 'System Volume Information', '$Recycle.Bin', 'ProgramData', 'Recovery')
    if ($skipFolders -contains $dir.Name) {
        continue
    }

    Write-Host "  Scanning: $($dir.Name)" -ForegroundColor Gray

    $size = Get-DirectorySize -Path $dir.FullName
    $sizeGB = [math]::Round($size/1GB, 2)

    $results += [PSCustomObject]@{
        Directory = $dir.Name
        Path = $dir.FullName
        SizeGB = $sizeGB
        SizeMB = [math]::Round($size/1MB, 2)
    }
}

Write-Host "`n`n───────────────────────────────────────────────────────" -ForegroundColor Cyan
Write-Host "TOP SPACE CONSUMERS" -ForegroundColor Cyan
Write-Host "───────────────────────────────────────────────────────" -ForegroundColor Cyan

$results | Sort-Object SizeGB -Descending | Select-Object -First 15 | ForEach-Object {
    $sizeDisplay = if ($_.SizeGB -ge 1) { "$($_.SizeGB) GB" } else { "$($_.SizeMB) MB" }
    Write-Host "$sizeDisplay - $($_.Directory)" -ForegroundColor White
}

# Return results as JSON for processing
return $results | Sort-Object SizeGB -Descending | ConvertTo-Json
