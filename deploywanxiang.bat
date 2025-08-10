@echo off

set id=%USERNAME%

for /f "tokens=1,2,* " %%i in ('REG QUERY HKEY_CURRENT_USER\Software\Rime\Weasel /v RimeUserDir ^| find /i "RimeUserDir"') do set "UserDir=%%k"

if defined UserDir (
    echo 变量 UserDir 的值不为空
) else set UserDir="C:\Users\%id%\AppData\Roaming\Rime"

echo "用户目录为： %UserDir%"

for /f "tokens=1,2,* " %%i in ('REG QUERY HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Rime\Weasel /v WeaselRoot ^| find /i "WeaselRoot"') do set "regvalue=%%k"

echo "安装路径为： %regvalue%"

set tables="%~dp0"

echo "初始化算法服务"

start "" "%regvalue%\WeaselServer.exe"

echo "延时 2 秒"

ping -n 2 127.0.0.1>nul

echo "结束算法服务"

TASKKILL /F /IM WeaselServer.exe

echo "延时 2 秒"

ping -n 2 127.0.0.1>nul

echo "清空「用户目录」，免其干扰新参数生效"

set  aPath="%UserDir%"\build
call:CleanDirfunc "%aPath%"

set  aPath="%UserDir%"\lua\lib
call:CleanDirfunc "%aPath%"

set  aPath="%UserDir%"\lua
call:CleanDirfunc "%aPath%"

set  aPath="%UserDir%"\icons
call:CleanDirfunc "%aPath%"

echo "已清空「build」"

cd "%UserDir%"

for /f "delims=" %%a in ('dir/s/ad/b^|sort /r') do (
echo,rd /s /Q "%%a"&& rd /s /Q "%%a"
)

DEL /F /A /Q "%UserDir%"\*

echo "1-成功清空「用户目录」"

echo "2-更新APPDATA目录"

md "%UserDir%\build"

echo d|xcopy /S /Y %tables%\wanxiang-base\* "%UserDir%\"

echo "3-已放好了所有「新文件」，即将唤醒算法服务"

ping -n 5 127.0.0.1>nul

echo "唤醒算法服服，预备重新部署"

start "" "%regvalue%\WeaselServer.exe"

echo "延时 2 秒"

ping -n 2 127.0.0.1>nul

echo "重新部署，即将恢复正常"

"%regvalue%/WeaselServer.exe" /weaseldir
echo "程序目录已打开"
"%regvalue%/WeaselServer.exe" /userdir

"%regvalue%/WeaselDeployer.exe" /deploy
echo "重新布署成功"

echo "用户目录已打开"

:CleanDirfunc
if exist "%1" (
   echo "%1" 路径非空
   DEL /F /A /Q %1\*
   rd /s /q %1
) else (
 echo "%1" 路径为空，已略过
)
GOTO :EOF

pause