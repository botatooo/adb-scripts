Import-Module -Name .\modules\get_adb.psm1

Write-Host "Don't forget to enable Developer Mode in WSA Settings" -ForegroundColor Yellow

(& $adb connect 127.0.0.1:58526) | Out-Null

$apk_path = Read-Host -Prompt "Enter the path to the APK file you want to install: "

If ($apk_path.StartsWith("/"))
{
    & $adb shell pm install --full $apk_path
}
ElseIf ($apk_path -match "^[A-Z]:.*")
{
    & $adb install $apk_path
}
