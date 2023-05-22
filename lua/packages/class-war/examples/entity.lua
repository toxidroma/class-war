local Boom, GetSurfaceData, TraceLine
do
  local _obj_0 = util
  Boom, GetSurfaceData, TraceLine = _obj_0.Explosion, _obj_0.GetSurfaceData, _obj_0.TraceLine
end
local Bomb
do
  local _class_0
  local _parent_0 = ENTITY
  local _base_0 = { }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "Bomb",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  local self = _class_0
  self.Base = 'base_gmodentity'
  self.Model = Model('models/props_junk/PopCan01a.mdl')
  self.Category = 'class-war.examples'
  self.Spawnable = true
  self.Initialize = function(self)
    self:SetModel(self.Model)
    if SERVER then
      self:PhysicsInit(SOLID_VPHYSICS)
      self:SetMoveType(MOVETYPE_VPHYSICS)
      self:SetUseType(SIMPLE_USE)
    end
    return self:PhysWake()
  end
  self.Use = function(self, ply)
    if self:IsPlayerHolding() then
      return 
    end
    ply:PickupObject(self)
    local pos = self:GetPos()
    local tr = TraceLine({
      start = pos,
      endpos = pos
    })
    local surfprop = GetSurfaceData(tr.SurfaceProps)
    surfprop = surfprop or GetSurfaceData(0)
    return self:EmitSound(surfprop.impactSoftSound)
  end
  self.Detonate = function(self)
    if self:IsValid() then
      return Boom(self:GetPos(), 256) and self:Remove()
    end
  end
  self.PhysicsCollide = function(self, data)
    if data.Speed > 64 then
      return self:EmitSound('SolidMetal.ImpactHard')
    end
  end
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Bomb = _class_0
end
local Trim
Trim = string.Trim
local Unstable
do
  local _class_0
  local _parent_0 = Bomb
  local _base_0 = { }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "Unstable",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  local self = _class_0
  self.Model = Model('models/Items/combine_rifle_ammo01.mdl')
  self.ImpactThreshold = 256
  self.GetOverlayText = function(self)
    return "explodes on impact at speed > " .. tostring(self.ImpactThreshold)
  end
  self.PhysicsCollide = function(self, data)
    _class_0.__parent.PhysicsCollide(self, data)
    if data.Speed > self.ImpactThreshold then
      return self:Detonate()
    end
  end
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Unstable = _class_0
end
local Sensitive
do
  local _class_0
  local _parent_0 = Unstable
  local _base_0 = { }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "Sensitive",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  local self = _class_0
  self.ImpactThreshold = 128
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Sensitive = _class_0
  return _class_0
end
