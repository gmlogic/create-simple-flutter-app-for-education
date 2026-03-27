$ssh = "C:\Windows\System32\OpenSSH\ssh.exe"
$scp = "C:\Windows\System32\OpenSSH\scp.exe"

$server = "gmlogick-panel"

$remotePath = "/var/www/clients/client5/web25/web"
$backupPath = "/var/www/clients/client5/web25/backup"

# VERSION
$version = Get-Date -Format "yyyyMMdd_HHmmss"

Write-Host "Version: $version" -ForegroundColor Cyan

# BUILD
Write-Host "Building Flutter Web..." -ForegroundColor Yellow
dart run tool/generate_build_info.dart
flutter build web --release #--no-tree-shake-icons --pwa-strategy=none

if ($LASTEXITCODE -ne 0) {
    Write-Host "Build failed!" -ForegroundColor Red
    exit 1
}

# BACKUP
Write-Host "Creating backup..." -ForegroundColor Yellow
& $ssh $server "mkdir -p $backupPath/$version && cp -r $remotePath/* $backupPath/$version/ 2>/dev/null"

# CLEAN - Διαγραφή όλων ΕΚΤΟΣ από stats και .htaccess
Write-Host "Cleaning old files (keeping stats & .htaccess)..." -ForegroundColor Yellow
& $ssh $server "find $remotePath -mindepth 1 -maxdepth 1 ! -name 'stats' ! -name '.htaccess' -exec rm -rf {} +"

# UPLOAD
Write-Host "Uploading files..." -ForegroundColor Yellow
& $scp -r build/web/* "${server}:$remotePath/"

# FIX PERMISSIONS (Προστασία από Error 500 και "κουτάκια" στα εικονίδια)
Write-Host "Fixing permissions (skipping stats folder)..." -ForegroundColor Yellow
& $ssh $server "find $remotePath -path '*/stats' -prune -o -type d -exec chmod 755 {} + && find $remotePath -path '*/stats' -prune -o -type f -exec chmod 644 {} +"

# DONE
Write-Host "----------------------------" -ForegroundColor Green
Write-Host "Deploy OK!" -ForegroundColor Green
Write-Host "URL: https://kids.gmhost.gr" -ForegroundColor Green
Write-Host "Version: $version" -ForegroundColor Green
