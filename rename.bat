@ECHO OFF

rem 删除用户

for /f "skip=4 tokens=1-3" %%i in ('net user') do (
    if not "%%i"=="命令成功完成。" echo %%i>>tem.txt
    if not "%%j"=="" echo %%j>>tem.txt
    if not "%%k"=="" echo %%k>>tem.txt
)
FOR /f " tokens=* delims=" %%i in ('FINDSTR /l /v "ECHO Administrator cloud_op Guest cloudbase-init " tem.txt') do (
ECHO 将要删除 %%i
net user %%i /delete
)
DEL /q tem.txt>nul

rem 修改管理员账号
set  user=Administrator
set  newuser=szlykj
wmic useraccount where name='%user%' call Rename %newuser%>nul
wmic useraccount where name='%newuser%' set PasswordExpires=False>nul
net user %newuser% sly2019#kj
net user guest /active:no

rem 修改完重启
shutdown /r /f /t 0
