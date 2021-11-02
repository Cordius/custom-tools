# 消除命令ls显示文件夹带有背景颜色
LS_COLORS='ex=0;35:ow=1;32'

# golang settings
export PATH=$PATH:/usr/local/go/bin:/home/cordius/go/bin:/usr/local/bin
export GOPATH=/home/cordius/go
go env -w GOPROXY=https://goproxy.cn,direct
go env -w GOSUMDB=off

# rust settings
export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
export RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup
