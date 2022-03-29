Get-Content -Raw .\modules\check_adb.ps1 | Invoke-Expression
Get-Content -Raw .\modules\get_app_name.ps1 | Invoke-Expression

# Get the packages that are installed
$Packages = (adb shell pm list packages)
# Clean it up
$Packages = $Packages -replace "package:",""
# Sort them
$Packages = $Packages | Sort-Object

## Next step: use package IDs to get the app names
Write-Host "All apps:" -ForegroundColor Blue
ForEach ($PackageID in $Packages)
{
    $AppName = Get-AppName -PackageID $PackageID
    # Print it out
    Write-Host "$AppName ($PackageID)" -ForegroundColor Yellow
}
