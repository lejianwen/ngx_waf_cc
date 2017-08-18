if whiteip() then
	elseif blockip() then
		log('blockip',ngx.var.request_uri,"-",getClientIp())
		exit_html()
		return
	else
		denycc()
		return
	end

