@echo off
chcp 65001 >nul
title 线材工艺计算工具 - 一键部署

set "SRC=E:\默认配置\Inputs\线材计算公式.html"
set "DEPLOY_DIR=E:\默认配置\Projects\wire-process-calc"
set "DEPLOY_FILE=%DEPLOY_DIR%\index.html"

echo ============================================
echo   线材工艺计算工具 - 一键部署脚本
echo ============================================
echo.

rem --- 检查源文件 ---
if not exist "%SRC%" (
    echo [错误] 找不到源文件：
    echo   %SRC%
    echo.
    echo 请确认文件存在后重试。
    pause
    exit /b 1
)

rem --- 备份旧文件（防止覆盖出错） ---
if exist "%DEPLOY_FILE%" (
    copy /Y "%DEPLOY_FILE%" "%DEPLOY_FILE%.bak" >nul
    echo [备份] 旧 index.html 已备份为 index.html.bak
)

rem --- 复制源文件 ---
copy /Y "%SRC%" "%DEPLOY_FILE%" >nul
echo [复制] 线材计算公式.html → index.html

rem --- 进入项目目录 ---
cd /d "%DEPLOY_DIR%"

rem --- git add ---
git add index.html
if %errorlevel% neq 0 (
    echo.
    echo [错误] git add 失败，请检查 git 配置。
    pause
    exit /b 1
)

rem --- 检查是否有变更 ---
git diff --cached --quiet
if %errorlevel% eq 0 (
    echo.
    echo [提示] 文件没有变化，无需提交。
    pause
    exit /b 0
)

rem --- git commit ---
set "TS=%date:~0,4%-%date:~5,2%-%date:~8,2%_%time:~0,2%%time:~3,2%"
git commit -m "update: 线材工艺计算工具 %TS%" 2>nul
if %errorlevel% neq 0 (
    echo.
    echo [错误] git commit 失败。
    pause
    exit /b 1
)
echo [提交] git commit 完成

rem --- git push ---
git push origin main 2>&1
if %errorlevel% neq 0 (
    echo.
    echo [错误] git push 失败，请检查网络连接。
    echo  提示：若为代理问题，执行：
    echo    git config --unset http.proxy
    echo    git config --unset https.proxy
    pause
    exit /b 1
)

echo.
echo ============================================
echo  ✅ 部署完成！
echo.
echo  线上地址：
echo  https://hazhanglei.github.io/wire-process-calc/
echo.
echo  GitHub 仓库：
echo  https://github.com/hazhanglei/wire-process-calc
echo.
echo  查看 Actions 状态：
echo  https://github.com/hazhanglei/wire-process-calc/actions
echo ============================================
pause
