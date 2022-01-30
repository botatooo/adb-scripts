Get-Content -Path .\modules\get_adb.ps1 | Invoke-Expression

Write-Host "Removed files: " -ForegroundColor Green

& .\get_removed_apps.ps1 -NoVerbose


Write-Host "Reinstalling apps..." -ForegroundColor Green

ForEach ($Package in $RemovedPackages) {
  & $adb shell pm install-existing --full --user all $Package
}