fx_version "cerulean"
use_experimental_fxv2_oal 'yes'
lua54 'yes'
game 'gta5'

ui_page 'web/build/index.html'

client_script "client/init.lua"
shared_scripts {
  'config.lua',
  '@ox_lib/init.lua'
}


files {
  'client/modules/*.lua',
  'web/build/index.html',
  'web/build/**/*'
}