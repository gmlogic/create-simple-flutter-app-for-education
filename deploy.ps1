$ssh = "C:\Windows\System32\OpenSSH\ssh.exe"
$scp = "C:\Windows\System32\OpenSSH\scp.exe"

$server = "gmlogick@100.66.6.42"
$port = 2332
$remotePath = "/var/www/clients/client5/web25/web"
$backupPath = "/var/www/clients/client5/web25/backup"

$version = Get-Date -Format "yyyyMMdd_HHmmss"

Write-Host "Version: $version"

Write-Host "Building..."
flutter build web

if ($LASTEXITCODE -ne 0) {
Write-Host "Build failed!"
exit 1
}

Write-Host "Creating backup..."
& $ssh -p $port $server "mkdir -p $backupPath/$version && cp -r $remotePath/* $backupPath/$version/"

Write-Host "Cleaning..."
& $ssh -p $port $server "rm -rf $remotePath/*"

Write-Host "Uploading..."
& $scp -P $port -r build/web/* "${server}:$remotePath/"

Write-Host "Deploy OK!"
Write-Host "https://kids.gmhost.gr/"
Write-Host "Version: $version"
