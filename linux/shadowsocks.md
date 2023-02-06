# 制作docker镜像
```Dockerfile
FROM busybox:latest
RUN wget https://github.com/shadowsocks/v2ray-plugin/releases/download/v1.3.2/v2ray-plugin-linux-amd64-v1.3.2.tar.gz -O v2ray-plugin.tar.gz \
    && tar -xvzf v2ray-plugin.tar.gz \
    && mv v2ray-plugin_linux_amd64 /usr/bin/v2ray-plugin

FROM shadowsocks/shadowsocks-libev:latest
ENV METHOD="xchacha20-ietf-poly1305"
ENV ARGS="--plugin v2ray-plugin --plugin-opts server"
COPY --from=0 /usr/bin/v2ray-plugin /usr/bin/v2ray-plugin
```
# 运行
密码和端口改成自己喜欢的，记得安全组打开该端口权限
```bash
docker run -d -e PASSWORD=abcd1234qwer --net=host -e SERVER_PORT=2010 shadowsocks:v2ray
```
