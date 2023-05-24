require('glua-extensions', 'https://github.com/Pika-Software/glua-extensions')
require('nw3-vars', 'https://github.com/Pika-Software/nw3-vars')
local logger = _PKG:GetLogger()
local gm = gmod.GetGamemode()
BIND = include('bind.lua')
ENTITY = include('entity.lua')
PLYCLASS = include('plyclass.lua')
SOUND = include('sound.lua')
UPLINK = include('uplink.lua')
WEAPON = include('weapon.lua')
do
  local _with_0 = CreateConVar('class-war_examples', 1, {
    FCVAR_REPLICATED,
    FCVAR_ARCHIVE
  }, "Change whether the examples are loaded. You'll need to restart the server for changes to take effect.")
  logger:Info("+CVAR/class-war_example: '" .. tostring(_with_0:GetString()) .. "'" .. (_with_0:GetInt() == tonumber(_with_0:GetDefault()) and '' or "( def. '" .. tostring(_with_0:GetDefault()) .. "' )"))
  logger:Info(" " .. tostring(_with_0:GetHelpText()))
  if _with_0:GetBool() then
    include('examples.lua')
  end
end
return {
  BIND = BIND,
  ENTITY = ENTITY,
  PLYCLASS = PLYCLASS,
  SOUND = SOUND,
  UPLINK = UPLINK,
  WEAPON = WEAPON
}
