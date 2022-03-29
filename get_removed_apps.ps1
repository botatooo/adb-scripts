Get-Content -Raw .\modules\check_adb.ps1 | Invoke-Expression
Get-Content -Raw .\modules\get_aapt.ps1 | Invoke-Expression
Get-Content -Raw .\modules\get_app_name.ps1 | Invoke-Expression

$CompareObjects = @{
    # Only the packages that are installed
    ReferenceObject = (adb shell pm list packages)
    # All the packages including the ones that are uninstalled
    DifferenceObject = (adb shell pm list packages -u)
}

# Get the uninstalled packages
$RemovedPackages = Compare-Object @CompareObjects -PassThru
# Clean it up
$RemovedPackages = $RemovedPackages -replace "package:",""
# Sort them
$RemovedPackages = $RemovedPackages | Sort-Object

## Next step: use package IDs to get the app names
Write-Host "Uninstalled apps:" -ForegroundColor Red
ForEach ($PackageID in $RemovedPackages)
{
    $AppName = Get-AppName -PackageID $PackageID
    # Print it out
    Write-Host "$AppName ($PackageID)" -ForegroundColor Yellow
}
