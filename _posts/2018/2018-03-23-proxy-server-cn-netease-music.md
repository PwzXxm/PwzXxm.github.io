---
layout: "post"
title: "Build a Proxy Server to Access Chinese IP Including Netease Music"
date: "2018-03-23 15:39"
lang: en
tags:
    - Tools
---

Sometimes we need to access Chinese content, like Youku Video, Netease Music(Cloud Music) and QQ music. It is very annoying to get "Can Only Be Streamed in Mainland China" or similar messages. Being tired of that, fortunately I have got a VPS from Aliyun and I build a proxy server using [Shadowsocks](https://shadowsocks.org/en/index.html) on it and everything works smoothly now.

### VPS
You need to have a VPS with **Chinese** IP address, there are tons of choices, like Aliyun(Alibaba Cloud) and Tencent Cloud etc.


### Install Server
Then `ssh` to your cloud server or any other tools to get into your server and install **Shadowsocks**, you can follow the instruction [here](https://shadowsocks.org/en/download/servers.html). I use the Python version.


### Config Shadowsocks
Config Shadowsocks, I usually write my configuration file in `/etc/shadowsocks/ss.json`. Please **NOTE** that the `server` attribute in most of the case should be your VPS' public IP address. However, AFAIK, for Aliyun and AWS, it will not work if you do so (Error message `socket.error: [Errno 99] Cannot assign requested address` will pop up when you try to run it). The reason is the public IP address is not the "actual" IP when it is used to bind IP and port to the VPS machine, it may refer to other VPS in the local network. Therefore, `0.0.0.0` to listen to all the IP addresses should be used.


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

### Optional
Install `m2crypto` to make encryption a little bit faster.

```bash
pip install m2crypto
```

If you want to use `chacha20` as encryption method, `libsodium` must be installed. Otherwise, you could use `aes-256-cfb`.

```bash
wget https://github.com/jedisct1/libsodium/releases/download/1.0.16/libsodium-1.0.16.tar.gz
tar -xf libsodium-1.0.16.tar.gz && cd libsodium-1.0.16
./configure && make -j2 && make install
echo /usr/local/lib > /etc/ld.so.conf.d/usr_local_lib.conf
ldconfig
```


### Run
Run the server as daemon!

```bash
ssserver -c /etc/shadowsocks/ss.json -d start
```

Alternatively, you can run the server at the front for debugging purpose, see all the traffic going through when you connected from the client later.

```bash
ssserver -c /etc/shadowsocks/ss.json
```

### Install Client
Finally, install clients on devices and start using it! You could install clients from [here](https://shadowsocks.org/en/download/clients.html). For macOS, I recommend [Shadowsocks X](https://github.com/yangfeicheung/Shadowsocks-X) with Overseas mode.

I prefer to use Shadowsocks client with PAC rather than using proxy for the overall system.

```js
var domains = {
  "music.163.com": 1,
  "music.126.net": 1,
  "*.v.163.com": 1,
  "*.music.163.com": 1,
  "*.music.126.net": 1,
};

var proxy = "__PROXY__";

var direct = 'DIRECT;';

var hasOwnProperty = Object.hasOwnProperty;

function FindProxyForURL(url, host) {
    var suffix;
    var pos = host.lastIndexOf('.');
    pos = host.lastIndexOf('.', pos - 1);
    while(1) {
        if (pos <= 0) {
            if (hasOwnProperty.call(domains, host)) {
                return proxy;
            } else {
                return direct;
            }
        }
        suffix = host.substring(pos + 1);
        if (hasOwnProperty.call(domains, suffix)) {
            return proxy;
        }
        pos = host.lastIndexOf('.', pos - 1);
    }
}
```

### Netease Music
You need to select *Using IE proxy*.

### More Information

It's only the basic setup for Shadowsocks. For advanced topics, check

- https://github.com/shadowsocks/shadowsocks/wiki

- https://shadowsocks.org/en/config/advanced.html




<br/>
<br/>