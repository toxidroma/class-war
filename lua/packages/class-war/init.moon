require 'glua-extensions', 'https://github.com/Pika-Software/glua-extensions'
require 'nw3-vars', 'https://github.com/Pika-Software/nw3-vars'
logger  = _PKG\GetLogger!
gm = gmod.GetGamemode!
import AddChangeCallback from cvars
export ENTITY = include'entity.lua'
export UPLINK = include'uplink.lua'
--TODO: CONVAR class
with CreateConVar 'class-war_examples', 1, {FCVAR_REPLICATED, FCVAR_ARCHIVE}, "Change whether the examples are loaded. You'll need to restart the server for changes to take effect."
    logger\Info "+CVAR/class-war_example: '#{\GetString!}'"..(\GetInt! == tonumber(\GetDefault!) and '' or "( def. '#{\GetDefault!}' )")
    logger\Info " #{\GetHelpText!}"
    include'examples.lua' if \GetBool!

{
    :ENTITY
    :UPLINK
}