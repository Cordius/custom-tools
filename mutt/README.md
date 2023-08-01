# 安装mutt组件
apt install mutt fdm msmtp
# 将配置文件放在用户目录下
cp .muttrc .fdm.conf .msmtprc ~
# 创建邮件目录 (更改如下路径时要在配置文件修改对应的路径)
mkdir ~/sandbox/mail -p
# crontab增加定时收邮件任务
```bash
*/5 * * * * fdm -l fetch
```

1. [fdm manual](https://github.com/nicm/fdm/blob/master/MANUAL)
