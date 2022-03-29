Get-Content -Raw .\modules\get_app_name.ps1 | Invoke-Expression

Write-Host "Removed files: " -ForegroundColor Green

$Params = @{
    # Only the packages that are installed
    ReferenceObject = (adb shell pm list packages)
    # All the packages including the ones that are uninstalled
    DifferenceObject = (adb shell pm list packages -u)
}

# Get the uninstalled packages
$RemovedPackages = Compare-Object @Params -PassThru
# Clean it up
$RemovedPackages = $RemovedPackages -replace 'package:',''
# Sort it
$RemovedPackages = $RemovedPackages | Sort-Object

Write-Host "Reinstalling apps..." -ForegroundColor Green

ForEach ($Package in $RemovedPackages)
{
    adb shell pm install-existing --full --user 0 $Package | Out-Null
    $AppName = Get-AppName -PackageID $Package
    Write-Host "Reinstalled $AppName ($Package)" -ForegroundColor Green
}
