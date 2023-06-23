install 'glua-extensions', 'https://github.com/Pika-Software/glua-extensions'
install 'nw3-vars', 'https://github.com/Pika-Software/nw3-vars'
logger  = _PKG\GetLogger!
gm = gmod.GetGamemode!

export BIND     = include'bind.moon'
export CIRCLE   = include'circle.moon'
export ENTITY   = include'entity.moon'
export FONT     = include'font.moon'
export PLAYER   = include'player.moon' 
export SOUND    = include'sound.moon'
export UPLINK   = include'uplink.moon'
export WEAPON   = include'weapon.moon'
export VGUI     = include'vgui.moon'
--TODO: CONVAR class
with CreateConVar 'class-war_examples', 1, {FCVAR_REPLICATED, FCVAR_ARCHIVE}, "Change whether the examples are loaded. You'll need to restart the server for changes to take effect."
    logger\Info "+CVAR/class-war_example: '#{\GetString!}'"..(\GetInt! == tonumber(\GetDefault!) and '' or "( def. '#{\GetDefault!}' )")
    logger\Info " #{\GetHelpText!}"
    if \GetBool!
        AddCSmoonFile'examples.moon'
        include'examples.moon' 

{
    :BIND
    :CIRCLE
    :ENTITY
    :FONT
    :PLAYER
    :SOUND
    :UPLINK
    :WEAPON
    :VGUI
}