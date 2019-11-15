@echo off

:Help
echo ====================== 系统安全日志汇总查看小程序 =========================
echo "                                                                        "                                                             
echo "                                                                        " 
echo                      综合表条目说明:      
echo "                                                                        " 
echo                      1、历史登陆用户IP----eventid=4624
echo "                                                                        " 
echo                      2、帐号密码修改记录--eventid=4738
echo "                                                                        " 
echo                      3、sourceIp列显示%%1794 为修改帐号密码记录行
echo "                                                                        "   
echo                      4、SubjectUsername---被修改密码的帐号
echo "                                                                        "                                 
echo "                                                                        " 
echo "                                                                        "      
echo                                                Version 2.0                                     
echo                                                by jimywu    
echo                                                2019/10/30
echo ============================================================================
pause

if not exist "c:\windows\system32\LogParser.exe" goto NoFile
goto Menu

:NoFile
 cd /d %~dp0
 copy /y .\LogParser.exe c:\windows\system32


:Menu
cls
echo==============================选择继续操作===================================
echo "                                                                          "
echo "                                                                          "
echo "                                                                          "
echo                        0、查看综合表                                                                          

echo                        1、查看登陆过此虚机的主机名
echo "                                                                          "
echo                        2、查看登陆过此虚机的IP
echo "                                                                          "
echo                        3、查看所有被修改帐号密码的记录
echo "                                                                          "
echo                        4、显示帮助信息
echo "                                                                          "
echo                        5、关闭程序
echo "                                                                          "
echo "                                                                          "
echo "                                                                          "
echo=============================================================================
set choose=0
set /p choose=请选择: (默认为0)

if "%choose%"=="0" goto run0
if "%choose%"=="1" goto run1
if "%choose%"=="2" goto run2
if "%choose%"=="3" goto run3
if "%choose%"=="4" goto Help
if "%choose%"=="5" goto exit
pause
exit


:run0
 LogParser.exe -stats:OFF -i:EVT "SELECT TimeGenerated AS Date, eventid,EXTRACT_TOKEN(Strings, 5, '|') as Username, EXTRACT_TOKEN(Strings, 6, '|') as Domain,EXTRACT_TOKEN(Strings, 1, '|') as SubjectUsername,EXTRACT_TOKEN(Strings, 17, '|') as PasswordLastSet,  EXTRACT_TOKEN(Strings, 18, '|') AS SourceIP FROM Security WHERE (eventid = 4624 AND EXTRACT_TOKEN(Strings, 8, '|') = '10' AND Username NOT IN ('SYSTEM'; 'ANONYMOUS LOGON'; 'LOCAL SERVICE';'NETWORK SERVICE';'cloudbase-init') AND Domain NOT IN ('NT AUTHORITY'))OR eventid = 4738   ORDER BY timegenerated DESC" -o:DATAGRID
goto Menu

:run1
LogParser.exe -stats:OFF -i:EVT -o:DATAGRID "SELECT DISTINCT EXTRACT_TOKEN(Strings, 11, '|') as workSationName FROM Security WHERE eventid = 4624 AND EXTRACT_TOKEN(Strings, 8, '|') = '3' "
goto Menu


:run2
LogParser.exe -stats:OFF -i:EVT -o:DATAGRID "SELECT DISTINCT EXTRACT_TOKEN(Strings, 18, '|') as SourceIP FROM Security WHERE eventid = 4624 AND EXTRACT_TOKEN(Strings, 8, '|') = '10'"
goto Menu


:run3
 LogParser.exe -stats:OFF -i:EVT "SELECT TimeGenerated AS Date,EXTRACT_TOKEN(Strings, 5, '|') as Username,EXTRACT_TOKEN(Strings, 1, '|') as SubjectUsername,EXTRACT_TOKEN(Strings, 17, '|') as PasswordLastSet FROM Security WHERE eventid = 4738 AND Username NOT IN ('cloudbase-init') ORDER BY Date DESC" -o:DATAGRID
goto Menu

:exit
exit




