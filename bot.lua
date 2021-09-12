local http, env, storage

function amogus.urlencode(url)
	url = url:gsub("\n", "\r\n")
	url = url:gsub("([^%w ])", function(c)
		return string.format("%%%02X", string.byte(c))
	end)
	url = url:gsub(" ", "+")
	return url
end

function amogus.parse_message(player, message, discord)
	if player ~= minetest.localplayer:get_name() then
		http.fetch({url = "http://localhost:6969?message=" .. amogus.urlencode(message), timeout = 100}, function(res)
			if res.succeeded then
				minetest.send_chat_message(res.data)
			end
		end)
	end
end

function amogus.reload()
	local func, err = env.loadfile("clientmods/amogus/bot.lua")
	if func then
		local old_amogus = table.copy(amogus)
		local status, init = pcall(func)
		if status then
			init(http, env, storage)
		else
			amogus = old_amogus
			return false, "Error: " .. init
		end
	else
		return false, "Syntax error: " .. err
	end
end

return function(_http, _env, _storage)
	http, env, storage = _http, _env, _storage
end
