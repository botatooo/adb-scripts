Import-Module -Name './modules/get_adb.psm1'

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
# Add aapt
Import-Module -Name "./modules/get_aapt.psm1"

Write-Host "Uninstalled apps:" -ForegroundColor Red
ForEach ($PackageID in $RemovedPackages) {
  # Default output
  $path = (adb shell pm list packages -u -f "$PackageID") | Select-Object -First 1
  # Cleaning it a bit
  $path = $path -replace "package:","" -replace "=$PackageID",""
  # Use AAPT to get the app name
  $AppName = (adb shell /data/local/tmp/aapt-arm-pie dump badging "$path")
  $AppName = $AppName | Select-String -Pattern "application-label:"
  # Clean it up
  $AppName = $AppName -replace "application-label:'","" -replace "'",""
  $AppName = $AppName -replace "\\",""
  # Print it out
  Write-Host "$AppName ($PackageID)" -ForegroundColor Yellow
}
