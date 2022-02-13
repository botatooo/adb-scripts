$commonAdbLocations = @(
  "$Env:LOCALAPPDATA\Android\sdk\platform-tools\adb.exe",
  "C:\platform-tools\adb.exe",
  "C:\adb\adb.exe"
)

Function Test-CommandExists {
  Param ([string] $command)
  $oldPreference = $ErrorActionPreference
  $ErrorActionPreference = "stop"
  try {
    if (Get-Command $command) {
      Return $true
    }
  } Catch {
    Return $false
  } Finally {
    $ErrorActionPreference = $oldPreference
  }
}

ForEach ($adbPath in $commonAdbLocations) {
  if (Test-Path -Path $adbPath) {
    $adb = $adbPath
    break
  }
}

if (!Get-Variable -Name adb -ErrorAction SilentlyContinue) {
  Write-Host "adb not found, downloading..."
  $adb_download_url = "https://dl.google.com/android/repository/platform-tools-latest-windows.zip"
  Invoke-WebRequest -Uri $adb_download_url -OutFile "$Env:TEMP\platform-tools.zip"
  Expand-Archive -LiteralPath "$Env:TEMP\platform-tools.zip" -DestinationPath "C:"
  Remove-Item -Path "$Env:TEMP\platform-tools.zip"
  $adb = "C:\platform-tools\adb.exe"
}

if ((& $adb get-state) -Contains "error") {
  Write-Host "Device not found. Connect your device and try again." -ForegroundColor Red
  exit 1
}
