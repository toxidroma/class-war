local PrecacheSound
PrecacheSound = util.PrecacheSound
do
  local _class_0
  local _base_0 = {
    channel = CHAN_AUTO,
    level = SNDLVL_NORM,
    volume = 1,
    pitch = {
      95,
      105
    },
    sound = { }
  }
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
    local snd = {
      name = child.__name
    }
    local ancestor = child
    while ancestor do
      for k, v in pairs(ancestor.__base) do
        local _continue_0 = false
        repeat
          if string.sub(k, 1, 2) == "__" then
            _continue_0 = true
            break
          end
          if not (snd[k]) then
            snd[k] = v
          end
          _continue_0 = true
        until true
        if not _continue_0 then
          break
        end
      end
      if not (ancestor.__parent) then
        break
      end
      ancestor = ancestor.__parent
    end
    if istable(snd.sound) then
      local _list_0 = snd.sound
      for _index_0 = 1, #_list_0 do
        local s = _list_0[_index_0]
        PrecacheSound(s)
      end
    else
      PrecacheSound(snd.sound)
    end
    return sound.Add(snd)
  end
  return _class_0
end
