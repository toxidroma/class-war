import insert from table

logger = _PKG\GetLogger!
class SYNCLASS
    @INSTANCES: {}
    VARS: {}
    @__inherited: (child) =>
        old_init = child.__init
        child.__init = (...) =>
            old_init @, ...
            mt = getmetatable @
            old_index = mt.__index
            mt.__index = (name) =>
                var = old_index.VARS[name]
                if var.get
                    var.get @
                else
                    if isfunction old_index
                        old_index @, name
                    else
                        old_index[name]
            if SERVER
                mt.__newindex = (key, value) =>
                    old = @DATA[key]
                    var = @VARS[key]
                    old = var.def if old == nil
                    unless old == value
                        --SYNC TO WITNESSES HERE
                        if var.set
                            @DATA[key] = var.set @, value
                        else
                            @DATA[key] = value
    if CLIENT
        @__base['new'] = (@ID) => @LoadFromNetwork!
    else
        @__base['new'] = =>
            @ID = insert SYNCLASS.INSTANCES
            @DATA = {}
            @WITNESSES = {}
            logger\Debug"+SYNCLASS-INSTANCE: #{@__name} [#{@ID}]"

class INFLUENCE extends SYNCLASS
    DecayFactor: 0
    DecayAfter: math.huge
    Minimum: -1
    Maximum: 1
    VARS:
        amount:
            get: => @amount or 0
            set: (new) => new unless new > @Maximum or new < @Minimum or not isnumber new
            def: 0

class Pain extends INFLUENCE
    DecayFactor: 1
    DecayAfter: 180
    Minimum: -4
    Maximum: 0