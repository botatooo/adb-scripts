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
$RemovedPackages = $RemovedPackages -replace 'package:',''
# Sort it
$RemovedPackages = $RemovedPackages | Sort-Object
