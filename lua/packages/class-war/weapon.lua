local Register
Register = weapons.Register
local lower, Left
do
  local _obj_0 = string
  lower, Left = _obj_0.lower, _obj_0.Left
end
local TraceLine
TraceLine = util.TraceLine
local logger = _PKG:GetLogger()
local gm = gmod.GetGamemode()
do
  local _class_0
  local _base_0 = { }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function() end,
    __base = _base_0,
    __name = nil
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
  self.__inherited = function(self, child)
    local fields
    do
      local _tbl_0 = { }
      for k, v in pairs(child) do
        if Left(k, 2) ~= "__" then
          _tbl_0[k] = v
        end
      end
      fields = _tbl_0
    end
    fields.Base = fields.Base or self.__barcode
    fields.Spawnable = fields.Spawnable or self.Spawnable
    fields.Category = fields.Category or self.Category
    child.__barcode = tostring(self.__barcode and self.__barcode .. '/' or '') .. tostring(lower(rawget(child, '__entity') or child.__name))
    Register(fields, child.__barcode)
    logger:Debug("+WEAPON: " .. tostring(child.__barcode))
    if CLIENT and gm.IsSandboxDerived and child.Spawnable then
      return timer.Create(tostring(_PKG), 1, 1, function()
        logger:Debug('Reloading the spawnmenu.')
        return RunConsoleCommand('spawnmenu_reload')
      end)
    end
  end
  return _class_0
end
