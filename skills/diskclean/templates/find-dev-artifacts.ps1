# Find Development Artifacts Script
# Identifies node_modules, build outputs, and other regenerable dev files

param(
    [Parameter(Mandatory=$true)]
    [string]$TargetPath
)

Write-Host "🔧 Scanning for development artifacts..." -ForegroundColor Cyan

$artifacts = @()

# Find node_modules directories
Write-Host "  Checking for node_modules..." -ForegroundColor Gray
$nodeModules = Get-ChildItem -Path $TargetPath -Recurse -Directory -Filter "node_modules" -ErrorAction SilentlyContinue |
    Select-Object -First 50  # Limit to first 50 to avoid overwhelming scan

foreach ($dir in $nodeModules) {
    $size = (Get-ChildItem -Path $dir.FullName -Recurse -File -ErrorAction SilentlyContinue |
             Measure-Object -Property Length -Sum).Sum
    $sizeMB = [math]::Round($size/1MB, 2)

    if ($sizeMB -gt 10) {  # Only report >10MB
        $artifacts += [PSCustomObject]@{
            Type = "node_modules"
            Name = "node_modules"
            Path = $dir.FullName
            SizeMB = $sizeMB
            Category = "Review"
            Safe = "Yes (regenerate with 'npm install')"
        }
    }
}

# Find build output directories
Write-Host "  Checking for build outputs..." -ForegroundColor Gray
$buildDirs = @('dist', 'build', 'out', '.next', 'target', '__pycache__')

foreach ($buildDir in $buildDirs) {
    $dirs = Get-ChildItem -Path $TargetPath -Recurse -Directory -Filter $buildDir -ErrorAction SilentlyContinue |
        Select-Object -First 20

    foreach ($dir in $dirs) {
        $size = (Get-ChildItem -Path $dir.FullName -Recurse -File -ErrorAction SilentlyContinue |
                 Measure-Object -Property Length -Sum).Sum
        $sizeMB = [math]::Round($size/1MB, 2)

        if ($sizeMB -gt 5) {  # Only report >5MB
            $artifacts += [PSCustomObject]@{
                Type = "Build Output"
                Name = $buildDir
                Path = $dir.FullName
                SizeMB = $sizeMB
                Category = "Review"
                Safe = "Yes (rebuild with build command)"
            }
        }
    }
}

# Find Python virtual environments
Write-Host "  Checking for Python venv..." -ForegroundColor Gray
$venvDirs = Get-ChildItem -Path $TargetPath -Recurse -Directory -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -in @('venv', 'env', '.venv') } |
    Select-Object -First 20

foreach ($dir in $venvDirs) {
    # Check if it looks like a venv (has Scripts/bin and Lib/lib)
    $hasScripts = Test-Path (Join-Path $dir.FullName "Scripts") -or Test-Path (Join-Path $dir.FullName "bin")

    if ($hasScripts) {
        $size = (Get-ChildItem -Path $dir.FullName -Recurse -File -ErrorAction SilentlyContinue |
                 Measure-Object -Property Length -Sum).Sum
        $sizeMB = [math]::Round($size/1MB, 2)

        if ($sizeMB -gt 10) {
            $artifacts += [PSCustomObject]@{
                Type = "Python venv"
                Name = $dir.Name
                Path = $dir.FullName
                SizeMB = $sizeMB
                Category = "Review"
                Safe = "Yes (recreate with 'python -m venv')"
            }
        }
    }
}

# Display results
if ($artifacts.Count -gt 0) {
    Write-Host "`n✓ Found $($artifacts.Count) development artifacts" -ForegroundColor Green

    $totalSizeMB = ($artifacts | Measure-Object -Property SizeMB -Sum).Sum
    Write-Host "  Total size: $([math]::Round($totalSizeMB/1024, 2)) GB" -ForegroundColor Yellow

    # Group by type
    $grouped = $artifacts | Group-Object -Property Type
    foreach ($group in $grouped) {
        $groupSize = ($group.Group | Measure-Object -Property SizeMB -Sum).Sum
        Write-Host "`n$($group.Name): $($group.Count) items, $([math]::Round($groupSize/1024, 2)) GB"
        $group.Group | Select-Object -First 5 | ForEach-Object {
            Write-Host "  - $([math]::Round($_.SizeMB/1024, 2)) GB - $($_.Path)" -ForegroundColor Gray
        }
        if ($group.Count -gt 5) {
            Write-Host "  ... and $($group.Count - 5) more" -ForegroundColor DarkGray
        }
    }
} else {
    Write-Host "`n✓ No development artifacts found" -ForegroundColor Green
}

return $artifacts | ConvertTo-Json
