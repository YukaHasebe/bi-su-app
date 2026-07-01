@echo off
REM Widgetbook（UIコンポーネントのカタログ）を Chrome で起動するランチャー
set "PATH=C:\src\flutter\bin;%PATH%"
cd /d "%~dp0"
echo === Widgetbook を起動します (flutter run -t lib/widgetbook/main.dart -d chrome) ===
echo (起動に30〜60秒ほどかかります。Chromeが自動で開きます)
call flutter run -t lib/widgetbook/main.dart -d chrome
pause
