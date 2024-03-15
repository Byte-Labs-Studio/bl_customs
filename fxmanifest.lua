fx_version "cerulean"
use_experimental_fxv2_oal 'yes'
lua54 'yes'
game 'gta5'

author "Byte Labs"
version '1.0.6'

repository 'Byte-Labs-Project/bl_customs'

ui_page 'web/build/index.html'
--ui_page 'http://localhost:5173/'

client_scripts {
  "@bl_bridge/imports/client.lua",
  "client/init.lua"
}

server_scripts {
  "@bl_bridge/imports/server.lua",
  "server/main.lua"
}

shared_script '@ox_lib/init.lua'

files {
  'config.lua',
  'client/modules/*.lua',
  'web/build/index.html',
  'web/build/**/*',
  "data/carcols_gen9.meta",
  "data/carmodcols_gen9.meta"
}

data_file "CARCOLS_GEN9_FILE" "data/carcols_gen9.meta"
data_file "CARMODCOLS_GEN9_FILE" "data/carmodcols_gen9.meta"
