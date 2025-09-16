fx_version "cerulean"
games { "gta5" }
lua54 "yes"

ui_page "html/index.html"

client_scripts {
    "client/cl_main.lua",
    "client/cl_functions.lua",
}

shared_scripts {
    "config.lua"
}

files {
    "html/index.html",
    "html/js/script.js",
    "html/css/style.css",
}


server_scripts {
    "@oxmysql/lib/MySQL.lua",
    "server/sv_tests.lua",
    "server/sv_functions.lua",
    "server/sv_main.lua",
}

-- Dependencies
dependencies {
    "oxmysql",
}
