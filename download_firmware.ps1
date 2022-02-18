$model = Read-Host -Prompt "Enter the model of the device: "
$region = Read-Host -Prompt "Enter the region of the device: "
$out = Get-Item -Path .\firmware\

if (samloader --help | Out-Null) {
    Write-Host "samloader is installing" -ForegroundColor Red
    python -m pip install git+https://github.com/nlscc/samloader.git
} else {
    Write-Host "samloader found" -ForegroundColor Green
}

$version = samloader -m $model -r $region checkupdate

Write-Debug "Version: $version"

Write-Host "Downloading firmware" -ForegroundColor Green
samloader -m $model -r $region download -v $version -O $out
Write-Host "Firmware downloaded" -ForegroundColor Green

Write-Host "Decrypting firmware" -ForegroundColor Green
$out = Get-Item -Path $out
$files = Get-ChildItem -Path $out -File -Filter *.zip.enc*
if ($files.Count -cge 1)
{
    $file = $files[0]
}
else
{
    Write-Host "No firmware found" -ForegroundColor Red
    exit 1
}

$zip = ($file.FullName -replace ".enc4" -replace ".enc2")
samloader -m $model -r $region decrypt -v "$version" -i $file -o $zip
Write-Host "Firmware decrypted" -ForegroundColor Green

Write-Host "Unzipping firmware" -ForegroundColor Green
$dir = New-Item -Path ($zip -replace ".zip") -ItemType Directory
Expand-Archive -Path $zip -DestinationPath $dir

Write-Host "----`nDone" -ForegroundColor Green