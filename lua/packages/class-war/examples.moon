include'examples/entity.lua'
include'examples/weapon.lua'
if CLIENT
    include'examples/font.lua'
    include'examples/vgui.lua'
else
    AddCSLuaFile'examples/font.lua'
    AddCSLuaFile'examples/vgui.lua'
