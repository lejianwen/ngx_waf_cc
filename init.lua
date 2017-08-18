require 'config'
function getClientIp()
	IP  = ngx.var.remote_addr 
	if IP == nil then
		IP  = "unknown"
	end
	return IP
end
function write(logfile,msg)
	local fd = io.open(logfile,"ab")
	if fd == nil then return end
	fd:write(msg)
	fd:flush()
	fd:close()
end
function log(method,url,data,ruletag)
	if attacklog then
		local realIp = getClientIp()
		local ua = ngx.var.http_user_agent
		local servername=ngx.var.server_name
		local time=ngx.localtime()
		if ua  then
			line = realIp.." ["..time.."] \""..method.." "..servername..url.."\" \""..data.."\"  \""..ua.."\" \""..ruletag.."\"\n"
		else
			line = realIp.." ["..time.."] \""..method.." "..servername..url.."\" \""..data.."\" - \""..ruletag.."\"\n"
		end
		local filename = logpath..'/'..servername.."_"..ngx.today().."_sec.log"
		write(filename,line)
	end
end
function exit_html()
	ngx.header.content_type = "text/html"
	ngx.status = ngx.HTTP_FORBIDDEN
	ngx.say(html)
	ngx.exit(ngx.status)
end
function denycc()
	if CCDeny then
		local uri=ngx.var.uri
		CCcount=tonumber(string.match(CCrate,'(.*)/'))
		CCseconds=tonumber(string.match(CCrate,'/(.*)'))
		local token = getClientIp()..uri
		local limit = ngx.shared.limit
		local req,_=limit:get(token)
		if req then
			if req > CCcount then
				log('CC',ngx.var.request_uri,"-",getClientIp())
				exit_html()
				return true
			else
				limit:incr(token,1)
			end
		else
			limit:set(token,1,CCseconds)
		end
	end
	return false
end
function whiteip()
	if next(ipWhitelist) ~= nil then
		for _,ip in pairs(ipWhitelist) do
			if getClientIp()==ip then
				return true
			end
		end
	end
	return false
end

function blockip()
	if next(ipBlocklist) ~= nil then
		for _,ip in pairs(ipBlocklist) do
			if getClientIp()==ip then
				return true
			end
		end
	end
	return false
end