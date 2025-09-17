fx_version 'cerulean'
game 'gta5'
lua54 'yes'
author 'Meteo'
description 'This script is designed for the meteo server'
version '1.2.0'

shared_scripts {
    '@qb-core/shared/locale.lua',
    'locales/en.lua',
    'locales/*.lua',
    'config.lua'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

ui_page 'html/index.html'

files {
    "html/js/*",
    'html/assets/*.png',
    'html/assets/*.jpg',
    'html/assets/*.gif',
    'html/assets/*.mp3',
    'html/index.html',
    'html/css/*',
}
