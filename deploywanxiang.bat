@echo off

set id=%USERNAME%

for /f "tokens=1,2,* " %%i in ('REG QUERY HKEY_CURRENT_USER\Software\Rime\Weasel /v RimeUserDir ^| find /i "RimeUserDir"') do set "UserDir=%%k"

if defined UserDir (
    echo ���� UserDir ��ֵ��Ϊ��
) else set UserDir="C:\Users\%id%\AppData\Roaming\Rime"

echo "�û�Ŀ¼Ϊ�� %UserDir%"

for /f "tokens=1,2,* " %%i in ('REG QUERY HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Rime\Weasel /v WeaselRoot ^| find /i "WeaselRoot"') do set "regvalue=%%k"

echo "��װ·��Ϊ�� %regvalue%"

set tables="%~dp0"

echo "��ʼ���㷨����"

start "" "%regvalue%\WeaselServer.exe"

echo "��ʱ 2 ��"

ping -n 2 127.0.0.1>nul

echo "�����㷨����"

TASKKILL /F /IM WeaselServer.exe

echo "��ʱ 2 ��"

ping -n 2 127.0.0.1>nul

echo "��ա��û�Ŀ¼������������²�����Ч"

set  aPath="%UserDir%"\build
call:CleanDirfunc "%aPath%"

set  aPath="%UserDir%"\lua\lib
call:CleanDirfunc "%aPath%"

set  aPath="%UserDir%"\lua
call:CleanDirfunc "%aPath%"

set  aPath="%UserDir%"\icons
call:CleanDirfunc "%aPath%"

echo "����ա�build��"

cd "%UserDir%"

for /f "delims=" %%a in ('dir/s/ad/b^|sort /r') do (
echo,rd /s /Q "%%a"&& rd /s /Q "%%a"
)

DEL /F /A /Q "%UserDir%"\*

echo "1-�ɹ���ա��û�Ŀ¼��"

echo "2-����APPDATAĿ¼"

md "%UserDir%\build"

echo d|xcopy /S /Y %tables%\wanxiang-base\* "%UserDir%\"

echo "3-�ѷź������С����ļ��������������㷨����"

ping -n 5 127.0.0.1>nul

echo "�����㷨������Ԥ�����²���"

start "" "%regvalue%\WeaselServer.exe"

echo "��ʱ 2 ��"

ping -n 2 127.0.0.1>nul

echo "���²��𣬼����ָ�����"

"%regvalue%/WeaselServer.exe" /weaseldir
echo "����Ŀ¼�Ѵ�"
"%regvalue%/WeaselServer.exe" /userdir

"%regvalue%/WeaselDeployer.exe" /deploy
echo "���²���ɹ�"

echo "�û�Ŀ¼�Ѵ�"

:CleanDirfunc
if exist "%1" (
   echo "%1" ·���ǿ�
   DEL /F /A /Q %1\*
   rd /s /q %1
) else (
 echo "%1" ·��Ϊ�գ����Թ�
)
GOTO :EOF

pause