include'examples/entity.moon'
include'examples/weapon.moon'
if CLIENT
    include'examples/font.moon'
    include'examples/vgui.moon'
else
    AddCSLuaFile'examples/font.moon'
    AddCSLuaFile'examples/vgui.moon'
