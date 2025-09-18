fx_version 'cerulean'
game 'gta5'
author 'FastScripts - f4st3r'
description 'Advanced radio script - discord.gg/fastscripts'
version 'release-1.3.1'
lua54 'yes'

files {
    "html/index.html",
    "html/js/*.js",
    "html/css/*.css",
    "html/img/*.png",
    "html/img/*.jpg",
    "html/fonts/*.ttf",
    "html/sound/*.mp3",
    "html/sound/*.ogg",
    "html/sound/*.wav",
    "html/img/custom/*.png",
    "html/img/custom/*.jpg",
    "html/js/node_modules/animejs/lib/*.js"
}

client_scripts {"client/*.lua"}
server_scripts {"@oxmysql/lib/MySQL.lua","server/*.lua", "shared/sv_config.lua"}
shared_scripts {"shared/sh_config.lua", "@ox_lib/init.lua"}

dependencies {
    'ox_lib'
}

escrow_ignore {
    "shared/*.lua",
    "server/*.lua",
    "client/*.lua"
}

ui_page 'html/index.html'
dependency '/assetpacks'