# Find Duplicate Files Script
# Identifies common duplicate patterns (installers, archives, etc.)

param(
    [Parameter(Mandatory=$true)]
    [string]$TargetPath
)

Write-Host "🔍 Scanning for duplicate files..." -ForegroundColor Cyan

$duplicates = @()

# Pattern 1: Files with (1), (2), etc. suffixes
Write-Host "  Checking for numbered duplicates..." -ForegroundColor Gray
$numberedFiles = Get-ChildItem -Path $TargetPath -Recurse -File -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -match '\s+\(\d+\)\.' }

foreach ($file in $numberedFiles) {
    $sizeMB = [math]::Round($file.Length/1MB, 2)
    if ($sizeMB -gt 1) {  # Only report files >1MB
        $duplicates += [PSCustomObject]@{
            Type = "Numbered Duplicate"
            File = $file.Name
            Path = $file.FullName
            SizeMB = $sizeMB
            Category = "Quick Win"
        }
    }
}

# Pattern 2: Multiple versions of same installer
Write-Host "  Checking for duplicate installers..." -ForegroundColor Gray
$installerPatterns = @{
    'postgresql' = '*postgresql*.exe'
    'cursor' = '*cursor*.exe'
    'vscode' = '*vscode*.exe'
    'python' = '*python*.exe'
    'node' = '*node*.exe'
    'git' = '*git*.exe'
}

foreach ($app in $installerPatterns.Keys) {
    $pattern = $installerPatterns[$app]
    $installers = Get-ChildItem -Path $TargetPath -Filter $pattern -Recurse -ErrorAction SilentlyContinue |
        Sort-Object LastWriteTime -Descending

    if ($installers.Count -gt 1) {
        # Keep newest, mark others as duplicates
        for ($i = 1; $i -lt $installers.Count; $i++) {
            $sizeMB = [math]::Round($installers[$i].Length/1MB, 2)
            $duplicates += [PSCustomObject]@{
                Type = "Duplicate Installer"
                File = $installers[$i].Name
                Path = $installers[$i].FullName
                SizeMB = $sizeMB
                Category = "Quick Win"
                Note = "Older version of $app (newer version exists)"
            }
        }
    }
}

# Pattern 3: Duplicate archives
Write-Host "  Checking for duplicate archives..." -ForegroundColor Gray
$archiveExts = @('.zip', '.rar', '.7z', '.tar.gz')
foreach ($ext in $archiveExts) {
    $archives = Get-ChildItem -Path $TargetPath -Filter "*$ext" -Recurse -ErrorAction SilentlyContinue |
        Group-Object -Property BaseName

    foreach ($group in $archives) {
        if ($group.Count -gt 1) {
            # Sort by date, keep newest
            $sorted = $group.Group | Sort-Object LastWriteTime -Descending
            for ($i = 1; $i -lt $sorted.Count; $i++) {
                $sizeMB = [math]::Round($sorted[$i].Length/1MB, 2)
                if ($sizeMB -gt 10) {  # Only report archives >10MB
                    $duplicates += [PSCustomObject]@{
                        Type = "Duplicate Archive"
                        File = $sorted[$i].Name
                        Path = $sorted[$i].FullName
                        SizeMB = $sizeMB
                        Category = "Review"
                        Note = "Possible duplicate (same base name)"
                    }
                }
            }
        }
    }
}

# Display results
if ($duplicates.Count -gt 0) {
    Write-Host "`n✓ Found $($duplicates.Count) duplicate files" -ForegroundColor Green

    $totalSizeMB = ($duplicates | Measure-Object -Property SizeMB -Sum).Sum
    Write-Host "  Total size: $([math]::Round($totalSizeMB/1024, 2)) GB" -ForegroundColor Yellow

    Write-Host "`nDuplicates found:"
    $duplicates | Format-Table -Property Type, File, SizeMB, Note -AutoSize
} else {
    Write-Host "`n✓ No obvious duplicates found" -ForegroundColor Green
}

return $duplicates | ConvertTo-Json
