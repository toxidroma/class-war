export *
name    = "class-war"
main    = "init.lua" --the file that is first loaded
cl_main = nil --if cl_main is set to a file, that is the first file the client loads instead of main
version = 000500

--allowed sides to run package, if client is false then the server will not send anything
client  = true
server  = true
menu    = false

--if false, the package will wait for import from another package before it executes
autorun = true

--don't touch it if you don't know what you're doing
isolation = true

-- client files
send = {
    "bind.lua"
    "entity.lua"
    "plyclass.lua"
    "sound.lua"
    "uplink.lua"
    "weapon.lua"
    "examples.lua"
    "examples/entity.lua"
    "examples/weapon.lua"
}

--if false, the logger will not be created by default
logger = true

--if nil, all gamemodes are allowed
gamemodes = nil --{
            --    "sandbox"
            --    "darkrp"
            --}

--if nil, all maps are allowed
maps = nil --{
            --"gm_construct"
        --}

--if true, then the package is allowed to run only in a singleplayer game
singleplayer = false