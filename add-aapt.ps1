Get-Content -Path .\modules\get_adb.ps1 | Invoke-Expression

& $adb push ./bin/aapt-arm-pie /data/local/tmp
& $adb shell chmod 0755 /data/local/tmp/aapt-arm-pie

Write-Host "AAPT has been added to the temporary directory of your device." -ForegroundColor Green
