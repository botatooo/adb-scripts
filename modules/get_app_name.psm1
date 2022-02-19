Import-Module -Name .\get_adb.psm1
Import-Module -Name .\get_aapt.psm1

Function Get-AppName
{
    Param ([string]$PackageID)
    # Default output
    $path = (& $adb shell pm list packages -u -f "$PackageID") | Select-Object -First 1
    # Cleaning it a bit
    $path = $path -replace "package:","" -replace "=$PackageID",""
    # Use AAPT to get the app name
    $AppName = (adb shell /data/local/tmp/aapt-arm-pie dump badging "$path")
    $AppName = $AppName | Select-String -Pattern "application-label:"
    # Clean it up
    $AppName = $AppName -replace "application-label:'","" -replace "'",""
    $AppName = $AppName -replace "\\",""
    Return $AppName
}