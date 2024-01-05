fx_version "cerulean"
use_experimental_fxv2_oal 'yes'
lua54 'yes'
game 'gta5'

author "Byte Labs"
version '1.0.3'

repository 'Byte-Labs-Project/bl_customs'

ui_page 'web/build/index.html'

client_scripts {
  "@bl_bridge/imports/client.lua",
  "client/init.lua"
}

server_scripts {
  "@bl_bridge/imports/server.lua",
  "server/main.lua"
}

shared_scripts {
  '@ox_lib/init.lua',
  'config.lua',
}

files {
  'client/modules/*.lua',
  'web/build/index.html',
  'web/build/**/*',
  "carcols_gen9.meta", 
  "carmodcols_gen9.meta"
}

data_file "CARCOLS_GEN9_FILE" "carcols_gen9.meta"
data_file "CARMODCOLS_GEN9_FILE" "carmodcols_gen9.meta"
