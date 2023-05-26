local band, bnot
do
  local _obj_0 = bit
  band, bnot = _obj_0.band, _obj_0.bnot
end
local Run
Run = hook.Run
local TranslatePlayerModel, TranslatePlayerHands, TranslateToPlayerModelName, RunClass, RegisterClass, SetPlayerClass, GetPlayerClass, GetPlayerClasses
do
  local _obj_0 = player_manager
  TranslatePlayerModel, TranslatePlayerHands, TranslateToPlayerModelName, RunClass, RegisterClass, SetPlayerClass, GetPlayerClass, GetPlayerClasses = _obj_0.TranslatePlayerModel, _obj_0.TranslatePlayerHands, _obj_0.TranslateToPlayerModelName, _obj_0.RunClass, _obj_0.RegisterClass, _obj_0.SetPlayerClass, _obj_0.GetPlayerClass, _obj_0.GetPlayerClasses
end
local lower, Left
do
  local _obj_0 = string
  lower, Left = _obj_0.lower, _obj_0.Left
end
local PrecacheModel
PrecacheModel = util.PrecacheModel
do
  local _with_0 = FindMetaTable('Player')
  _with_0.RunClass = function(self, fn, ...)
    if self:ClassTable()[fn] then
      return RunClass(self, fn, ...)
    end
  end
  _with_0.ClassName = function(self)
    return GetPlayerClass(self)
  end
  _with_0.ClassTable = function(self)
    return GetPlayerClasses()[self:ClassName()]
  end
end
local id = _PKG:GetIdentifier('player')
hook.Add('StartCommand', id, function(ply, cmd)
  return ply:RunClass('StartCommand', cmd)
end)
hook.Add('PlayerPostThink', id, function(ply)
  return ply:RunClass('Think')
end)
if CLIENT then
  hook.Add('PrePlayerDraw', id, function(ply, flags)
    return ply:RunClass('PrePlayerDraw', flags)
  end)
  hook.Add('PostPlayerDraw', id, function(ply, flags)
    return ply:RunClass('PostPlayerDraw', flags)
  end)
  hook.Add('HUDPaint', id, function()
    return LocalPlayer():RunClass('HUDPaint')
  end)
  hook.Add('HUDDrawTargetID', id, function()
    return LocalPlayer():RunClass('HUDDrawTargetID')
  end)
  hook.Add('PostDrawOpaqueRenderables', id, function()
    return LocalPlayer():RunClass('PostDrawOpaqueRenderables')
  end)
  hook.Add('InputMouseApply', id, function(...)
    return LocalPlayer():RunClass('InputMouseApply', ...)
  end)
else
  hook.Add('PostPlayerDeath', id, function(ply)
    return ply:RunClass('PostPlayerDeath')
  end)
  hook.Add('SetupPlayerVisibility', id, function(ply, viewEntity)
    if IsValid(viewEntity) then
      AddOriginToPVS(viewEntity:WorldSpaceCenter())
    end
    return ply:RunClass('SetupPlayerVisibility', viewEntity)
  end)
end
local PLAYER
do
  local _class_0
  local _base_0 = {
    DisplayName = 'Default Class',
    SlowWalkSpeed = 150,
    WalkSpeed = 250,
    RunSpeed = 350,
    CrouchedWalkSpeed = .3,
    DuckSpeed = .3,
    UnDuckSpeed = .3,
    JumpPower = 200,
    CanUseFlashlight = false,
    MaxHealth = 100,
    MaxArmor = 100,
    StartHealth = 100,
    StartArmor = 0,
    DropWeaponOnDie = false,
    TeammateNoCollide = false,
    AvoidPlayers = true,
    UseVMHands = true,
    SetupDataTables = function(self)
      self._NetworkVars = {
        String = 0,
        Bool = 0,
        Float = 0,
        Int = 0,
        Vector = 0,
        Angle = 0,
        Entity = 0
      }
      Run('SetupPlayerDataTables', self)
      return self.Player
    end,
    NetworkVar = function(self, varType, name, extended)
      local index = assert(self._NetworkVars[varType], "Attempt to register unknown network var type " .. tostring(varType))
      local max
      if varType == 'String' then
        max = 3
      else
        max = 31
      end
      if index >= max then
        error("Network var limit exceeded for " .. tostring(varType))
      end
      self.Player:NetworkVar(varType, index, name, extended)
      self._NetworkVars[varType] = self._NetworkVars[varType] + 1
    end,
    Init = function(self) end,
    SetModel = function(self)
      local modelname = TranslatePlayerModel(self.Player:GetInfo('cl_playermodel'))
      PrecacheModel(modelname)
      return self.Player:SetModel(modelname)
    end,
    Death = function(self, inflictor, attacker) end,
    GetViewOrigin = function(self)
      return self.Player:EyePos(), self.Player:EyeAngles()
    end,
    Think = function(self) end,
    StartCommand = function(self) end,
    GetTraceFilter = function(self)
      return {
        self.Player
      }
    end,
    GetHandPosition = function(self)
      return self.Player:GetPos(), self.Player:GetAngles()
    end,
    CalcView = function(self, view)
      view.origin, view.angles = self:GetViewOrigin()
    end,
    HUDPaint = function(self) end,
    HUDDrawTargetID = function(self) end,
    PostDrawOpaqueRenderables = function(self) end,
    CreateMove = function(self, cmd) end,
    ShouldDrawLocal = function(self) end,
    StartMove = function(self, mv, cmd) end,
    Move = function(self, mv)
      if self.Player.GetState then
        return self.Player:GetStateTable():Move(self.Player, mv)
      end
    end,
    FinishMove = function(self, mv) end,
    Spawn = function(self)
      return self:Loadout(self.Player)
    end,
    SetupPlayerVisibility = function(self, viewEntity)
      return AddOriginToPVS(self:GetViewOrigin())
    end,
    Loadout = function(self) end,
    ViewModelChanged = function(self, vm, old, new) end,
    PreDrawViewModel = function(self, vm, weapon) end,
    PostDrawViewModel = function(self, vm, weapon) end,
    GetHandsModel = function(self)
      return TranslatePlayerHands(TranslateToPlayerModelName(self.Player))
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, ply)
      self.ply = ply
      return SetPlayerClass(self.ply, self.__class.__barcode)
    end,
    __base = _base_0,
    __name = "PLAYER"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  local self = _class_0
  self.__barcode = 'player'
  self.__inherited = function(self, child)
    local fields
    do
      local _tbl_0 = { }
      for k, v in pairs(child.__base) do
        if Left(k, 2) ~= "__" then
          _tbl_0[k] = v
        end
      end
      fields = _tbl_0
    end
    child.__barcode = tostring(self.__barcode and self.__barcode .. '/' or '') .. tostring(lower(child.__name))
    return RegisterClass(child.__barcode, fields, self.__barcode)
  end
  PLAYER = _class_0
end
RegisterClass('player', PLAYER.__base, nil)
return PLAYER
