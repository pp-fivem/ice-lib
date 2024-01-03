fx_version 'cerulean'
game 'gta5'
use_experimental_fxv2_oal 'yes'
lua54 'yes'

author "ICE DEVELOPMENT | prefoo & peevee999"
description 'An important library that we use in the bridges of our scripts'
version '1.0.0'

shared_scripts {
    "@ox_lib/init.lua",
}

client_scripts {
    'client/main.lua',
    'client/zoneCreator.lua',
    'client/bridge/*.lua',
}

server_scripts {
    'server/main.lua',
    'server/bridge/*.lua',
}