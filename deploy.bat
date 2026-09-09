@echo off
setlocal
title Wire Process Calc - One-Click Deploy

set "DEPLOY_DIR=E:\default\Projects\wire-process-calc"

echo ============================================
echo   Wire Process Calc - One-Click Deploy
echo   (Edit index.html, then run this script)
echo ============================================
echo.

cd /d "%DEPLOY_DIR%"
if not errorlevel 1 goto :add

echo [ERROR] Project dir not found:
echo   %DEPLOY_DIR%
goto :end

:add
git add -A
if errorlevel 1 (
    echo.
    echo [ERROR] git add failed. Check git setup.
    goto :end
)

rem Check if there is actually anything to commit
git diff --cached --quiet
if not errorlevel 1 (
    echo.
    echo [OK] No changes detected. Nothing to commit.
    goto :end
)

set "TS=%date:~0,4%-%date:~5,2%-%date:~8,2%_%time:~0,2%%time:~3,2%"
git commit -m "update wire-process-calc %TS%"
if errorlevel 1 (
    echo.
    echo [ERROR] git commit failed.
    goto :end
)
echo [COMMIT] git commit done.

git push origin main
if errorlevel 1 (
    echo.
    echo [ERROR] git push failed. Check network / proxy:
    echo    git config --unset http.proxy
    echo    git config --unset https.proxy
    goto :end
)

echo.
echo ============================================
echo  Deployed!
echo  Live:  https://hazhanglei.github.io/wire-process-calc/
echo  Repo:  https://github.com/hazhanglei/wire-process-calc
echo  CI:    https://github.com/hazhanglei/wire-process-calc/actions
echo ============================================
goto :end

:end
echo.
pause
endlocal
