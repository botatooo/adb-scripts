Function Get-AndroidDebugBridge
{
    $PlatformTools = "https://dl.google.com/android/repository/platform-tools-latest-windows.zip"
    Invoke-WebRequest -Uri $PlatformTools -OutFile "$Env:TEMP\platform-tools.zip"
    Expand-Archive -LiteralPath "$Env:TEMP\platform-tools.zip" -DestinationPath "C:"
    Remove-Item -Path "$Env:TEMP\platform-tools.zip"
    Return "C:\platform-tools\"
}

Function Add-ToEnv
{
    Param (
        [Parameter(Mandatory=$true, Position=0, ParameterSetName="Path")]
        [string]
        $path
    )

    If (-not (Test-Path -Path $path)) {
        Throw "Invalid path: `"$path`""
    }

    $regEnv = "Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment"
    $oldPath = (Get-ItemProperty -Path "$regEnv").Path
    $newPath = "$oldPath;$path"
    Set-ItemProperty -Path "$regEnv" -Value $newPath
    Return "$newPath"
}

If (-not (Get-Command adb -ErrorAction SilentlyContinue))
{
    Write-Host "adb not found, downloading..."
    $adb = New-AndroidDebugBridge
    Add-ToEnv -Path "$adb"
}
