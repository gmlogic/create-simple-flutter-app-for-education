Write-Host "Cleaning Flutter repository from build/cache files..." -ForegroundColor Cyan

# Remove tracked build/cache files from git index
git rm -r --cached build 2>$null
git rm -r --cached .dart_tool 2>$null
git rm -r --cached android/build 2>$null
git rm -r --cached android/.gradle 2>$null
git rm -r --cached ios/Flutter 2>$null
git rm -r --cached ios/Pods 2>$null
git rm -r --cached macos/Flutter 2>$null
git rm -r --cached .idea 2>$null
git rm -r --cached *.iml 2>$null

# Clean flutter build artifacts locally
flutter clean

# Restore dependencies
flutter pub get

Write-Host ""
Write-Host "Re-adding valid project files..." -ForegroundColor Cyan
git add .

Write-Host ""
Write-Host "Creating commit..." -ForegroundColor Cyan
git commit -m "Clean repository ignore build and cache files"

Write-Host ""
Write-Host "Done. Repository cleaned." -ForegroundColor Green