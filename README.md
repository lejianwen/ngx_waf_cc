# ngx_waf_cc
nginx的cc防火墙，基于lua-nginx-module(openresty) , 根据loveshell/ngx_lua_waf，只留下cc防护功能
因为只需要用到cc防护，就把cc防护单独拿出来了
## 安装
### 请先自行安装好nginx和lua-nginx-module
下载到指定目录后解压
比如 /data/docs/lua/ngx_waf_cc
## 配置
在nginx.conf的http段添加
~~~nginx
#/data/docs/lua/ngx_waf_cc 是解压后的目录,根据情况自行替换
lua_package_path "/data/docs/lua/ngx_waf_cc/?.lua;;";
lua_shared_dict limit 10m;
init_by_lua_file  /data/docs/lua/ngx_waf_cc/init.lua; 
access_by_lua_file /data/docs/lua/ngx_waf_cc/waf_cc.lua;  #可以写到server段中
~~~
### 配置文件说明
~~~lua
logpath = "/data/logs/nginx/waf_cc/" --攻击日志目录，请确认目录存在,并且有写入权限
attacklog = true --攻击日志是否开启
ipWhitelist={"127.0.0.1","10.7.20.73"} -- ip白名单,多个用逗号隔开
ipBlocklist={"10.7.20.73"}	--	ip黑名单，多个用逗号隔开
CCDeny=true	-- 是否开启 true || false
CCrate="100/60" -- CC攻击频率   次数/时间 , 100/60 表示60s内100次
html = [[ notice html! ]]
~~~
### TIPS
1.优先匹配白名单，在白名单里的IP不受限制，即使黑名单中存在，也会通过请求。
2.黑名单中的IP直接拦截。

# 感谢原作者[春哥](https://github.com/agentzh/)和[loveshell](https://github.com/loveshell/)两位大神
