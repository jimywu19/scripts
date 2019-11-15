@echo off
echo ======= 批量帐号创建工具 =======
echo
echo         用于一次性批量创建
echo         远程登录管理员帐号
echo       
echo        
echo                       by jimywu    
echo                       2019/4/24
echo ================================


:loop
set usern=user
set num=3
set /p usern=请输入用户名前缀，直接回车则使用'user'：
set /p num=请输入创建用户个数，默认为3个：
echo 你将创建'user001,user002..之类的用户名'
set /p pass=请输入用户密码，设置数字、字母特殊符号3种以上：
#if %ch% == 1 goto add
#if %ch% == 2 goto change
#if %ch% == 3 goto delete
#if %ch% == 0 goto end
#echo 输入无效，请重新选择&&goto loop



for /l %%a in (1,1,%%num) do (
net user "%%usern%%a" "%%pass" /add
net localgroup "administrators" "%%usern%%a" /add)
goto end


:change
set /p passwd=请输入新密码（）
for /l %%a in (1,1,3) do (
net user "test0%%a" %passwd%
)
goto end


:delete
for /l %%a in (1,1,3) do (
net user "test0%%a" /delete /y
)
goto end


:end
@echo "运行完成"
pause



