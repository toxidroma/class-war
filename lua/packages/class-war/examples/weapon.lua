local Punch
do
  local _base_0 = require('vpunch-local', 'https://github.com/toxidroma/vpunch-local')
  local _fn_0 = _base_0.Punch
  Punch = function(...)
    return _fn_0(_base_0, ...)
  end
end
local Gun
do
  local _class_0
  local _parent_0 = WEAPON
  local _base_0 = { }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "Gun",
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
  self.Category = 'class-war.examples'
  self.Spawnable = true
  self.UseHands = true
  self.AccurateCrosshair = true
  self.CanPrimaryAttack = function(self)
    if not ((self:Clip1() <= 0) or (self:GetNextPrimaryFire() >= CurTime())) then
      return true
    end
  end
  self.PrimaryAttack = function(self)
    if self:CanPrimaryAttack() then
      self:EmitSound(self.Primary.Sound)
      self:ShootBullet(self.Primary.Damage, 1, .01)
      self:TakePrimaryAmmo(1)
      self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
      return true
    end
  end
  self.CanSecondaryAttack = function(self)
    if not ((self:Clip2() <= 0) or (self:GetNextSecondaryFire() >= CurTime())) then
      return true
    end
  end
  self.SecondaryAttack = function(self)
    if self:CanSecondaryAttack() then
      self:EmitSound(self.Secondary.Sound)
      self:ShootBullet(self.Secondary.Damage, 1, .01)
      return self:TakeSecondaryAmmo(1)
    end
  end
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Gun = _class_0
end
local random
random = math.random
local Pistol
do
  local _class_0
  local _parent_0 = Gun
  local _base_0 = { }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "Pistol",
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
  self.WorldModel = Model('models/weapons/w_pistol.mdl')
  self.ViewModel = Model('models/weapons/c_pistol.mdl')
  self.PrimaryAttack = function(self)
    if _class_0.__parent.PrimaryAttack(self) then
      if CLIENT then
        return Punch(Angle(random(-1, -3), random(-2, 2), random(-1, 1)))
      end
    end
  end
  self.Primary = {
    Ammo = 'Pistol',
    ClipSize = 18,
    DefaultClip = 36,
    Damage = 13,
    Delay = 60 / 600,
    Sound = 'Weapon_Pistol.Single'
  }
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Pistol = _class_0
end
local Auto
do
  local _class_0
  local _parent_0 = Pistol
  local _base_0 = { }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "Auto",
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
  self.Primary = {
    Ammo = 'Pistol',
    ClipSize = 18,
    DefaultClip = 36,
    Damage = 13,
    Delay = 60 / 600,
    Sound = 'Weapon_Pistol.Single',
    Automatic = true
  }
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Auto = _class_0
  return _class_0
end
