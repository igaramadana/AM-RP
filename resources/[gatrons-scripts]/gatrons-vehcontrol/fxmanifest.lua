fx_version 'cerulean'
game 'gta5'
author 'https://discord.gg/2G96dasQPM'
description 'This script is specifically modified for the MeteoNp4 server.'
client_scripts {
    'client/cl_*.lua'
}

server_scripts {
    'server/sv_*.lua'
}

lua54 'yes'
escrow_ignore {
   'html/*',
   'config.lua'	 
}