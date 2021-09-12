amogus = {}

local http = minetest.request_http_api()
local env = minetest.request_insecure_environment()
local storage = minetest.get_mod_storage()

libclamity.register_on_chat_message(function(...)
	amogus.parse_message(...)
end)

minetest.register_chatcommand("amogus_reload", {
	func = function()
		return amogus.reload(http, env, storage)
	end
})

loadfile(minetest.get_modpath("amogus") .. "/bot.lua")()(http, env, storage)

