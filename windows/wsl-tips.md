# 固定wsl2 IP
1. 将下列命令保存为脚本
```bat
# 设置WSL2的IP为172.10.10.20/20
wsl -u root ip addr add 172.10.10.20/20 broadcast 172.10.10.1 dev eth0 label eth0:1
# 设置Windows的IP为172.10.10.10/20
netsh interface ip add address "vEthernet (WSL)" 172.10.10.10 255.255.240.0
```
2. 控制面板->管理工具->任务计划程序->设定任务计划程序   
  将上述脚本文件添加刀任务计划程序中，启动时执行  
# 外部机器ssh登录WSL2
1. WSL2内部安装openssh-server
```sh
sudo apt install openssh-server
# 修改/etc/ssh/sshd_config文件，监听地址0.0.0.0，允许密码登录等
sudo service ssh start
```
2. windows设置
```bat
# 管理员权限打开cmd执行下列命令添加端口转发规则
netsh interface portproxy add v4tov4 listenaddress=0.0.0.0 listenport=22 connectaddress=172.10.10.20 connectport=22
# 管理员权限打开cmd执行下列命令放开22端口的防火墙限制
netsh advfirewall firewall add rule name=”Open Port 22 for WSL2” dir=in action=allow protocol=TCP localport=22
# 删除上述规则
netsh int portproxy reset all
```
# WSL配置
保存以下文件到`C:\users\zongyong.wzy\.wslconfig`
```
[wsl2]
memory=4GB # Limits VM memory in WSL 2 to 4 GB
swap=4GB
kernelCommandLine=ipv6.disable=1
nestedVirtualization=true
```
参考 https://learn.microsoft.com/zh-cn/windows/wsl/wsl-config
