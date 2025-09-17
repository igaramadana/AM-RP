lua54 'yes' fx_version 'cerulean' game 'gta5' lua54 'yes' version '1.0.6'



author 'GG Studio'
description 'GG studio | Discord: https://discord.gg/GMbRek7SFa'



shared_scripts {
    '@ox_lib/init.lua',
    'utility.lua',
    'config/lang.lua',
    'config/shared/*.lua',
}

ui_page 'base/ui/dist/index.html'
-- ui_page "http://localhost:5173/" -- IGNORE

files {
    'utility.lua',
    'core/shared.lua',
    'core/bridge/**/**/*.lua',

    'base/ui/dist/index.html',
    'base/ui/dist/**/*'
}
server_scripts {    
    '@oxmysql/lib/MySQL.lua',
    'core/init/server.lua',
    'core/lib/**/server.lua',
    'base/build/server/*.lua',
    'base/core/**/server.lua',
}

client_scripts { 
    'core/init/client.lua',
    'core/lib/**/client.lua',
    'base/build/client/*.lua',
    'base/core/**/client.lua',
}

escrow_ignore {
    'core/shared.lua',
    'core/lib/**/client.lua',
    'core/lib/**/server.lua',
    'core/bridge/**/**/*.lua',

    'utility.lua',
    'config/lang.lua',
    'config/shared/*.lua',
}
dependency '/assetpacks'