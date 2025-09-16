fx_version "cerulean"
game "gta5"

author "CozyCode"
description "A multi-framework farming resource"
website 'http://cozy-coding.com//'
discord 'https://discord.gg/4cW6DR5q2U'

shared_scripts {
	"@ox_lib/init.lua",
	"config.lua",
	"bridge/qb/*.lua",
	"modules/**/shared.lua",
	"core/shared.lua",
	"locales/locale.lua",
	"locales/translations/*.lua"
}

client_scripts {
	"bridge/qb/client.lua",
	"modules/**/client.lua",
	"core/client.lua"
}

server_scripts {
	"bridge/qb/server.lua",
	"modules/**/server.lua",
	"core/server.lua"
}

lua54 'yes'

ui_page 'modules/html/index.html'

files {
	'modules/html/index.html'
}
