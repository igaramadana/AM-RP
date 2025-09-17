fx_version 'cerulean'
lua54 'yes'
game 'gta5'
author 'NarellGanteng'
description 'Narel Sigma'
version '1.1'

client_scripts {
	'client/client.lua'
}

shared_scripts {
    '@ox_lib/init.lua',
    'configs/headbag_config.lua'
}

server_scripts {
    'server/server.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/js/*.js',
    'html/css/*.css',
    'html/bag.png'
}
export 'headbag'