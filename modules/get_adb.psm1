$commonAdbLocations = @(
  "$Env:LOCALAPPDATA\Android\sdk\platform-tools\adb.exe",
  "C:\platform-tools\adb.exe",
  "C:\adb\adb.exe"
)

Function New-AndroidDebugBridge
{
    $platform_tools = "https://dl.google.com/android/repository/platform-tools-latest-windows.zip"
    Invoke-WebRequest -Uri $platform_tools -OutFile "$Env:TEMP\platform-tools.zip"
    Expand-Archive -LiteralPath "$Env:TEMP\platform-tools.zip" -DestinationPath "C:"
    Remove-Item -Path "$Env:TEMP\platform-tools.zip"
    Return "C:\platform-tools\adb.exe"
}

# try to find adb in the common locations
ForEach ($adbPath in $commonAdbLocations)
{
    If (Test-Path -Path $adbPath) {
        $adb = $adbPath
        break
    }
}

If (!(Get-Variable -Name adb -ErrorAction SilentlyContinue))
{
    Write-Host "adb not found, downloading..."
    $adb = New-AndroidDebugBridge
    $env:Path = "$adb;" + $env:Path
}

If ((& $adb get-state) -Contains "error")
{
    Write-Host "Device not found. Connect your device and try again." -ForegroundColor Red
    exit 1
}
