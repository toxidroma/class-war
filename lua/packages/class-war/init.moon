--install 'glua-extensions', 'https://github.com/Pika-Software/glua-extensions'
install 'nw3-vars', 'https://github.com/Pika-Software/nw3-vars'
logger  = _PKG\GetLogger!
gm = gmod.GetGamemode!
export BIND     = include'bind.lua'
export CIRCLE   = include'circle.lua'
export ENTITY   = include'entity.lua'
export PLAYER   = include'player.lua' 
export SOUND    = include'sound.lua'
export UPLINK   = include'uplink.lua'
export WEAPON   = include'weapon.lua'
--TODO: CONVAR class
with CreateConVar 'class-war_examples', 1, {FCVAR_REPLICATED, FCVAR_ARCHIVE}, "Change whether the examples are loaded. You'll need to restart the server for changes to take effect."
    logger\Info "+CVAR/class-war_example: '#{\GetString!}'"..(\GetInt! == tonumber(\GetDefault!) and '' or "( def. '#{\GetDefault!}' )")
    logger\Info " #{\GetHelpText!}"
    if \GetBool!
        AddCSLuaFile'examples.lua'
        include'examples.lua' 

{
    :BIND
    :CIRCLE
    :ENTITY
    :PLAYER
    :SOUND
    :UPLINK
    :WEAPON
}