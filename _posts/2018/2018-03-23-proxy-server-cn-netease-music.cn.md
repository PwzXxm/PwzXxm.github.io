---
layout: "post"
title: "搭建代理服务器以访问国内网络（网易云音乐)"
date: "2018-03-23 15:39"
lang: cn
tags:
    - Tools
---

身在国外，我们有时候需要看看优酷，听听网易云音乐、QQ音乐。看到“仅限中国大陆播放”的时候真的好气啊。公用的代理服务器我又有点强迫症，正好手头上有个阿里云的服务器，就用[Shadowsocks](https://shadowsocks.org/en/index.html)搭建了一个，现在可以开心地听歌啦。

### VPS
你需要一个有中国公网IP地址地服务器。国内服务器有很多选择，比如阿里云，腾讯云，美团云之类的。

### 安装服务器端
用`ssh`或者其他工具进入服务器，然后安装**Shadowsocks**。关于安装的步骤，可以看[这里](https://shadowsocks.org/en/download/servers.html)。 我用的是Python的版本。

### 配置Shadowsocks
我平常都把配置文件放在`/etc/shadowsocks/ss.json`。请**注意**`server`那一项平常都改填你VPS的公网IP地址。可是如果在阿里云，等下跑的时候会报错`socket.error: [Errno 99] Cannot assign requested address`。原因是因为你的“真实”IP地址并不是公网IP在阿里云内，所以在socket捆绑IP和端口的时候会报错。填`0.0.0.0`来监听所有端口就可以了。

```json
{
	"server":"0.0.0.0",
	"server_port":8080,
	"local_port":1080,
	"password":"yourpassword",
	"timeout":600,
	"method":"chacha20"
}
```

### 可选项
安装`m2crypto`加解密更快一些

```bash
pip install m2crypto
```

如果你想用`chacha20`来加密，你需要安装`libsodium`这个包。不然的话也可以用`aes-256-cfb`，大多数系统都自带这个方法。

```bash
wget https://github.com/jedisct1/libsodium/releases/download/1.0.16/libsodium-1.0.16.tar.gz
tar -xf libsodium-1.0.16.tar.gz && cd libsodium-1.0.16
./configure && make -j2 && make install
echo /usr/local/lib > /etc/ld.so.conf.d/usr_local_lib.conf
ldconfig
```

### 运行
当作守护进程运行

```bash
ssserver -c /etc/shadowsocks/ss.json -d start
```

当然也可以在前端运行，你可以看到所有代理的IP地址经过服务器。

```bash
ssserver -c /etc/shadowsocks/ss.json
```

### 安装Shadowsocks客户端
最后一步，在要用的设备上安装相关客户端。你可以在[这里](https://shadowsocks.org/en/download/clients.html)找到。苹果系统上我觉得[Shadowsocks X](https://github.com/yangfeicheung/Shadowsocks-X)的海外模式比较好用。


### 网易云音乐
请选择*使用IE代理*。

### 更多信息

这只是最简单的Shadowsocks服务器搭建，更多信息请查看：

- https://github.com/shadowsocks/shadowsocks/wiki

- https://shadowsocks.org/en/config/advanced.html



<br/>
<br/>