$model = Read-Host -Prompt "Enter the model of the device: "
$region = Read-Host -Prompt "Enter the region of the device (CSC Code): "

Try
{
    $out = Get-Item -Path .\firmware\
}
Catch
{
    New-Item -Path .\firmware\ -ItemType Directory
    $out = Get-Item -Path .\firmware\
}

Function Find-Model
{
  Param([PSObject] $item)
  If ($item[0] -contains $model)
  {
    return $item
  }
  Else
  {
    If ($null -ne $item[1])
    {
      $item.Remove($item[0])
      return Find-Model $item
    }
    Else
    {
      return $false
    }
  }
}

If (Get-Command -Name samloader -ErrorAction Ignore)
{
    Write-Host "samloader found" -ForegroundColor Green
}
Else
{
  Write-Host "samloader is installing" -ForegroundColor Red
  Try
  {
    python -m pip install git+https://github.com/nlscc/samloader.git
  }
  Catch
  {
    Write-Host "Python or PIP missing from PATH" -ForegroundColor Red
  }
}

$version = samloader -m $model -r $region checkupdate

Write-Debug "Version: $version"

Write-Host "Downloading firmware" -ForegroundColor Green
samloader -m $model -r $region download -v $version -O $out
Write-Host "Firmware downloaded" -ForegroundColor Green

Write-Host "Decrypting firmware" -ForegroundColor Green
$out = Get-Item -Path $out
$files = Get-ChildItem -Path $out -File -Filter *.zip.enc*
If ($files.Count -lt 1)
{
  Write-Host "No firmware found" -ForegroundColor Red
  exit 1
}
Else
{
  $file = $files | Sort-Object -Property Name
  If (($files | Select-Object -First 1) -notcontains "$model") {
    Find-Model $files
  }
}

$zip = ($file.FullName -replace ".enc4" -replace ".enc2")
samloader -m $model -r $region decrypt -v "$version" -i $file -o $zip
Write-Host "Firmware decrypted" -ForegroundColor Green

Write-Host "Unzipping firmware" -ForegroundColor Green
$dir = New-Item -Path ($zip -replace ".zip") -ItemType Directory
Expand-Archive -Path $zip -DestinationPath $dir

Write-Host "---- Done" -ForegroundColor Green