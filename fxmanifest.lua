-- Resource Metadata
fx_version 'cerulean'
games   { 'rdr3', 'gta5' } 
lua54 'yes'
author 'miskaslzickou'
description ''
version '1.0.0'

dependencies {
	
    'ox_target',
    'ox_lib'
    
}
-- What to run
client_script 'main.lua'
    
 ui_page 'html/index.html'
 files {'html/index.html',
        'html/sack.jpg',
        'html/vignette.png',
        'locales/*.json'

}


server_script {"server.lua","@oxmysql/lib/MySQL.lua"}



shared_scripts {'@ox_lib/init.lua','config.lua', '@es_extended/imports.lua' }