$adb = "C:\platform-tools\adb.exe";

if ((& $adb get-state) -Contains "error") {
  Write-Host "Device not found. Connect your device and try again." -ForegroundColor Red
  exit 1
}
