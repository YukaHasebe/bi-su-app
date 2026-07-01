@echo off
REM BI-SU 会員アプリ (Flutter) を Chrome で起動するランチャー
REM このファイルをダブルクリックするだけでOK。終了するときは黒い画面で q を押す。
set "PATH=C:\src\flutter\bin;%PATH%"
cd /d "%~dp0"
echo === flutter pub get ===
call flutter pub get
echo === flutter run -d chrome ===
echo (起動に30〜60秒ほどかかります。Chromeが自動で開きます)
call flutter run -d chrome
pause
