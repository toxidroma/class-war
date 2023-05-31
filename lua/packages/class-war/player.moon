import band, bnot from bit
import Run from hook
import TranslatePlayerModel, TranslatePlayerHands, TranslateToPlayerModelName, RunClass,
    RegisterClass, SetPlayerClass, GetPlayerClass, GetPlayerClasses from player_manager
import lower, Left from string
import PrecacheModel from util

with FindMetaTable 'Player'
    .RunClass = (fn, ...) => 
        cls = @ClassTable!
        if cls and cls[fn]
            RunClass @, fn, ...
    .ClassName = => GetPlayerClass @
    .ClassTable = => GetPlayerClasses![@ClassName!]

id = _PKG\GetIdentifier('player')
hook.Add 'StartCommand', id, (ply, cmd) -> ply\RunClass 'StartCommand', cmd
hook.Add 'PlayerPostThink', id, (ply) -> ply\RunClass 'Think'
if CLIENT
    hook.Add 'PrePlayerDraw', id, (ply, flags) -> ply\RunClass 'PrePlayerDraw', flags
    hook.Add 'PostPlayerDraw', id, (ply, flags) -> ply\RunClass 'PostPlayerDraw', flags
    hook.Add 'HUDPaint', id, -> LocalPlayer!\RunClass 'HUDPaint'
    hook.Add 'HUDDrawTargetID', id, -> LocalPlayer!\RunClass 'HUDDrawTargetID'
    hook.Add 'PostDrawOpaqueRenderables', id, -> LocalPlayer!\RunClass 'PostDrawOpaqueRenderables'
    hook.Add 'InputMouseApply', id, (...) -> LocalPlayer!\RunClass 'InputMouseApply', ...
else
    hook.Add 'PostPlayerDeath', id, (ply) -> ply\RunClass 'PostPlayerDeath'
    hook.Add 'SetupPlayerVisibility', id, (ply, viewEntity) ->
        AddOriginToPVS viewEntity\WorldSpaceCenter! if IsValid viewEntity
        ply\RunClass 'SetupPlayerVisibility', viewEntity

class PLAYER
    @__inherited: (child) =>
        fields = {k,v for k,v in pairs(child.__base) when Left(k, 2) != "__"}
        child.__barcode = "#{@__barcode and @__barcode .. '/' or ''}#{lower(child.__name)}"
        RegisterClass child.__barcode, fields, @__barcode and @__barcode or nil
    
    new: (@ply) => SetPlayerClass @ply, @@__barcode

    DisplayName:        'Default Player Class'
    SlowWalkSpeed:      150
    WalkSpeed:          250
    RunSpeed:           350
    CrouchedWalkSpeed:  .3
    DuckSpeed:          .3
    UnDuckSpeed:        .3
    JumpPower:          200
    CanUseFlashlight:   false
    MaxHealth:          100
    MaxArmor:           100
    StartHealth:        100
    StartArmor:         0
    DropWeaponOnDie:    false
    TeammateNoCollide:  false
    AvoidPlayers:       true
    UseVMHands:         true

    SetupDataTables: => 
        @_NetworkVars = 
            String: 0
            Bool:   0
            Float:  0
            Int:    0
            Vector: 0
            Angle:  0
            Entity: 0
        Run 'SetupPlayerDataTables', @
        @Player 

    NetworkVar: (varType, name, extended) =>
        index = assert @_NetworkVars[varType], "Attempt to register unknown network var type #{varType}"
        max = if varType == 'String'
            3
        else
            31
        error "Network var limit exceeded for #{varType}" if index >= max
        @Player\NetworkVar varType, index, name, extended
        @_NetworkVars[varType] += 1

    Init: => --SHARED, runs when the class is instanced for a new spawning player

    SetModel: =>
        modelname = TranslatePlayerModel @Player\GetInfo 'cl_playermodel'
        PrecacheModel modelname
        @Player\SetModel modelname
    
    Death: (inflictor, attacker) =>

    GetViewOrigin: => @Player\EyePos!, @Player\EyeAngles!

    Think: =>
    
    StartCommand: =>

    GetTraceFilter: => {@Player}

    GetHandPosition: => @Player\GetPos!, @Player\GetAngles!

    --CLIENT
    CalcView: (view) => view.origin, view.angles = @GetViewOrigin!
    HUDPaint: =>
    HUDDrawTargetID: =>
    PostDrawOpaqueRenderables: =>
    CreateMove: (cmd) =>
    ShouldDrawLocal: =>

    --SHARED
    StartMove: (mv, cmd) => 
    Move: (mv) => @Player\GetStateTable!\Move @Player, mv if @Player.GetState
    FinishMove: (mv) =>

    --SERVER
    Spawn: => @Loadout @Player
    SetupPlayerVisibility: (viewEntity) => AddOriginToPVS @GetViewOrigin!
    Loadout: =>

    ViewModelChanged: (vm, old, new) =>
    PreDrawViewModel: (vm, weapon) =>
    PostDrawViewModel: (vm, weapon) =>
    GetHandsModel: => TranslatePlayerHands TranslateToPlayerModelName @Player
RegisterClass 'player', PLAYER, nil
PLAYER