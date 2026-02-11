fx_version 'cerulean'
game 'gta5'

author 'smq scripts'
description 'Advanced vehicle key management system'
version '1.0.0'

-- [!] ATTENTION: Please read the README.md file before installation and use!
-- [!] Support / Discord: https://discord.gg/z7x6dD3yXm

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client/client.lua' 
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/server.lua' 
}

dependencies {
    'es_extended',
    'ox_lib',
    'ox_target',
    'ox_inventory'
}

-- Metadata & Links
repository 'https://github.com/smqscripts/smq_jobgarage'
discord 'https://discord.gg/z7x6dD3yXm'

youtube 'https://www.youtube.com/watch?v=Bb6phzY8UUc'
