Get-Content -Raw .\modules\check_adb.ps1 | Invoke-Expression

$aapt_doesnt_exists = (adb shell "[ -f /data/local/tmp/aapt-arm-pie ] || echo lorem")

If ($aapt_doesnt_exists -eq "lorem")
{
    adb push .\bin\aapt-arm-pie /data/local/tmp
    adb shell chmod 0755 /data/local/tmp/aapt-arm-pie
    Write-Host "AAPT has been added to the temporary directory of your device." -ForegroundColor Green
}
Else
{
    Write-Host "AAPT is already on your device." -ForegroundColor Green
}
