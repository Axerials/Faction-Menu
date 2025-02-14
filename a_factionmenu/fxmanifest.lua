fx_version 'cerulean'
game 'gta5'
lua54 'yes'
Author 'Axerials'
description 'Fre Faction menu Utilizing ox_lib.'
version '1.0'

client_scripts {
    'config.lua',
    'client/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua'
}

dependencies {
    'es_extended',  
    'ox_lib',    
}

shared_script {
    '@es_extended/imports.lua',
    'config.lua',
    '@ox_lib/init.lua',
}
