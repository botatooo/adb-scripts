Import-Module -Name .\modules\get_adb.psm1
Import-Module -Name .\modules\get_aapt.psm1
Import-Module -Name .\modules\get_app_name.psm1

$Params = @{
    # Only the packages that are installed
    ReferenceObject = (& $adb shell pm list packages)
    # All the packages including the ones that are uninstalled
    DifferenceObject = (& $adb shell pm list packages -u)
}

# Get the uninstalled packages
$RemovedPackages = Compare-Object @Params -PassThru
# Clean it up
$RemovedPackages = $RemovedPackages -replace "package:",""
# Sort it
$RemovedPackages = $RemovedPackages | Sort-Object

## Next step: use package IDs to get the app names
Write-Host "Uninstalled apps:" -ForegroundColor Red
ForEach ($PackageID in $RemovedPackages)
{
    $AppName = Get-AppName -PackageID $PackageID
    # Print it out
    Write-Host "$AppName ($PackageID)" -ForegroundColor Yellow
}
