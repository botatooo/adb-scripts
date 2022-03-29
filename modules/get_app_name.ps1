Get-Content -Raw .\modules\check_adb.ps1 | Invoke-Expression
Get-Content -Raw .\modules\get_aapt.ps1 | Invoke-Expression

Function Get-AppName
{
    Param (
        [Parameter(Mandatory=$true, Position=0)]
        [string]
        $PackageID
    )
    # Default output
    $path = (adb shell pm list packages -u -f "$PackageID") | Select-Object -First 1
    # Cleaning it a bit
    $path = $path -replace "package:","" -replace "=$PackageID",""
    Try
    {
        # Use AAPT to get the app name
        $AppName = (adb shell /data/local/tmp/aapt-arm-pie dump badging "$path")
        If ($AppName -icontains "error")
        {
            Throw
        }
        $AppName = $AppName | Select-String -Pattern "application-label:"
        # Clean it up
        $AppName = $AppName -replace "application-label:'","" -replace "'",""
        $AppName = $AppName -replace "\\",""
    }
    Catch
    {
        # Use last part of Package ID in case of failure
        $PackageURL = $PackageID.Split(".")
        $AppName = $PackageURL[$PackageURL.Count - 1]
    }

    Return $AppName
}
