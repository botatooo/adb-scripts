Import-Module -Name .\get_adb.psm1

$aapt_doesnt_exists = (& $adb shell "[ -f /data/local/tmp/aapt-arm-pie ] || echo 1")

if ($aapt_doesnt_exists -eq 1)
{
    & $adb push ../bin/aapt-arm-pie /data/local/tmp
    & $adb shell chmod 0755 /data/local/tmp/aapt-arm-pie
    Write-Host "AAPT has been added to the temporary directory of your device." -ForegroundColor Green
}
else
{
    Write-Host "AAPT is already on your device." -ForegroundColor Red
}
