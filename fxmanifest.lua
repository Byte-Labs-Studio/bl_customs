fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'
lua54 'yes'
game 'gta5'

author 'Byte Labs'
version '2.2.1'
repository 'Byte-Labs-Project/bl_customs'

dependency 'bl_bridge'

shared_script '@ox_lib/init.lua'

client_scripts {
  '@bl_bridge/imports/client.lua',
  'client/init.lua'
}

server_scripts {
  '@bl_bridge/imports/server.lua',
  'server/main.lua'
}

ui_page 'web/build/index.html'
--ui_page 'http://localhost:5173/'

files {
  'data/*.lua',
  'client/modules/*.lua',
  'web/build/index.html',
  'web/build/**/*',
  'data/chameleon/*.meta',
}

data_file 'CARCOLS_GEN9_FILE' 'data/chameleon/carcols_gen9.meta'
data_file 'CARMODCOLS_GEN9_FILE' 'data/chameleon/carmodcols_gen9.meta'
