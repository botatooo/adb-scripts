Get-Content -Path .\modules\get_adb.ps1 | Invoke-Expression

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
& $adb push ./bin/aapt-arm-pie /data/local/tmp
& $adb shell chmod 0755 /data/local/tmp/aapt-arm-pie

Write-Host "AAPT has been added to the temporary directory of your device." -ForegroundColor Green

$RemovedApps = @()

ForEach ($PackageID in $RemovedPackages) {
  # Default output
  $path = (adb shell pm list packages -u -f "$PackageID") | Select-Object -First 1
  # Cleaning it a bit
  $path = $path -replace "package:","" -replace "=$PackageID",""
  # Use AAPT to get the app name
  $AppName = (adb shell /data/local/tmp/aapt-arm-pie dump badging "$path")
  # Clean it up
  $AppName = $AppName | Select-String -Pattern "application-label:"
  $AppName = $AppName -replace "application-label:'","" -replace "'",""
  $AppName = $AppName -replace "\\",""
  # Print it out
  $RemovedApps += @($AppName, $PackageID)
}

Write-Host $RemovedApps -ForegroundColor Yellow

# Print it into the console (with a new line seperating them)
ForEach ($App in $RemovedApps) {
  $AppName = $App[0]
  $Package = $App[1]
  Write-Host "$AppName"," ($Package)" -ForegroundColor Red,Yellow
}

#Write-Host ($RemovedApps -join [Environment]::NewLine) -ForegroundColor Red
