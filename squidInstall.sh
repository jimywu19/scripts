#!/bin/bash
#
# centos版本，squid安装
# 2019.11.15  v1.3
#

#安装squid
[ -x '/usr/sbin/squid' ]||yum install -y squid
[ -x '/usr/bin/htpasswd' ]||yum install -y httpd-tools

#修改配置文件
sed -i '/http_access deny all/d' "/etc/squid/squid.conf"
sed -i 's/http_port 3128/http_port 31028/' "/etc/squid/squid.conf"
cat <<EOF>>/etc/squid/squid.conf 

# require user auth 
auth_param basic program /usr/lib64/squid/basic_ncsa_auth /etc/squid/passwd
acl auth_user proxy_auth REQUIRED
http_access allow auth_user
http_access deny all
EOF

#增加用户
htpasswd -bc /etc/squid/passwd zhangsanfeng AZos8N908kOc  >>/dev/null 2>&1

#增加自启动，运行
systemctl enable squid
systemctl start squid

#修改ssh默认端口
sed -i 's/#Port 22/Port 3022/' /etc/ssh/sshd_config
systemctl restart sshd

#防火墙放通代理端口
firewall-cmd --add-port 31028/tcp
firewall-cmd --add-port 31028/tcp --permanent
 
