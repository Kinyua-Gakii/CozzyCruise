Write-Host "Nuking everything..." -ForegroundColor Yellow

# Kill any lingering java/dart processes
Stop-Process -Name "java" -Force -ErrorAction SilentlyContinue
Stop-Process -Name "dart" -Force -ErrorAction SilentlyContinue

# Project level
Remove-Item -Recurse -Force ".dart_tool" -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force "build" -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force "android\.gradle" -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force "android\app\build" -ErrorAction SilentlyContinue

# System level
cmd /c "rd /s /q %USERPROFILE%\.gradle\caches"
cmd /c "rd /s /q %USERPROFILE%\.gradle\wrapper\dists"
cmd /c "rd /s /q %USERPROFILE%\AppData\Local\Pub\Cache"

# Rebuild fresh
flutter clean
flutter pub get

Write-Host "Done! Now run: flutter run" -ForegroundColor Green