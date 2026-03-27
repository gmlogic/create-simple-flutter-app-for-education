$ssh = "C:\Windows\System32\OpenSSH\ssh.exe"

$server = "gmlogick@100.66.6.42"
$port = 2332
$remotePath = "/var/www/clients/client5/web25/web"
$backupPath = "/var/www/clients/client5/web25/backup"

Write-Host "Available backups:"
& $ssh -p $port $server "ls -1 $backupPath"

$version = Read-Host "Enter version to restore"

if ([string]::IsNullOrWhiteSpace($version)) {
    Write-Host "No version entered"
    exit
}

Write-Host "Rolling back to $version..."

$cmd = "mkdir -p $backupPath/current_backup ; cp -r $remotePath/* $backupPath/current_backup/ ; rm -rf $remotePath/* ; cp -r $backupPath/$version/* $remotePath/"
# $cmd = "chattr -R -i $remotePath 2>/dev/null || true; mkdir -p $backupPath/current_backup; rsync -a --delete $remotePath/ $backupPath/current_backup/; rm -rf $remotePath/*; rsync -a $backupPath/$version/ $remotePath/; chmod -R 755 $remotePath"

& $ssh -p $port $server $cmd

Write-Host "Rollback completed!"