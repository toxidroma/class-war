import min, max from math
import ReadUInt, WriteUInt from net
import insert from table

export class UPLINK_SYNCLASSES extends UPLINK
    @Callback: (ply) => 
        return unless IsValid ply
        return if ply\GetNWBool _PKG\GetIdentifier'loaded'
        ply\SetNWBool _PKG\GetIdentifier'loaded', true
        SYNCLASS.READY[ply] = true

export SYNCLASS_INSTANCES or= {}

util.AddNetworkString'SYNCLASS_UPDATE'
class SYNCLASS
    @READY: {}
    VARS: {}
    __inherited: (cls) =>
        old_init = cls.__init
        cls.__init = (...) =>
            old_init @, ...

            mt           = getmetatable @
            old_index    = mt.__index
            old_newindex = mt.__newindex

            mt.__index = (name) => do
                if getter = (old_index.VARS[name] and old_index.VARS[name].get)
                    getter @
                else
                    if type(old_index) == "function"
                        old_index @, name
                    else
                        old_index[name]

            mt.__newindex = (name, value) =>
                if setter = (old_index.VARS[name] and old_index.VARS[name].set)
                    if setVal = setter @, value
                        old = @[idx]
                        var = @VARS[idx]
                        old = var.def if old == nil
                        rawset @, "_#{name}", setVal
                        @SYNC idx if old != setVal
                else
                    if type(old_newindex) == "function"
                        old_newindex @, name, value
                    else
                        rawset(@, name, value)
    new: (@ID) =>
        @LoadFromNetwork! if CLIENT
        if SERVER
            @ID = insert SYNCLASS_INSTANCES, @
            @WITNESSES = {}
    if CLIENT
        @__base.ReadNetworkData: (multi) =>
            idx = ReadUInt 8
            old = @[idx]
            var = @VARS[idx]
            old = var.def if old == nil
            @[idx] = net["Read#{var.Type}"][unpack var.TypeArgs]
            data = @[idx]
            if multi
                return
                    Name: var.Name
                    Old: old
                    New: new
        @__base.Download: =>
            cache = {}
            insert cache, @ReadNetworkData true for i=1,ReadUInt 8
    else
        @__base.SYNC: (idx) =>
            unless @NetDestroying
                net.Start'SYNCLASS_UPDATE'
                WriteUInt @ID, 16
                @WriteNetworkData idx
                net.Send table.GetKeys @WITNESSES
        @__base.WriteNetworkData: (idx) =>
            if idx
                data = @[idx]
                var = @VARS[idx]
                data = var.def if data == nil
                WriteUInt idx, 8
                net["Write#{var.type}"] data, unpack var.TypeArgs
            else
                WriteUInt table.Count(@VARS), 8
                @WriteNetworkData k for k in pairs @VARS
        @__base.GetReceivers: => {ply,true for ply in *player.GetAll!}
        @__base.UpdateReceivers: =>
            return if @NetDestroying
            old = @WITNESSES
            new = @GetReceivers!
            for k in pairs old
                if new[k]
                    old[k] = nil
                    new[k] = nil
            new[k] = nil unless @@READY[k] for k in pairs new
            @NetworkCreate table.GetKeys new
            @NetworkDestroy table.GetKeys old
            @WITNESSES = new
            @WITNESSES
class INFLUENCE extends SYNCLASS
    Minimum: 0
    Maximum: 3
    VARS:
        amount:
            get: => @_amount
            set: (new) => min @Maximum, max @Minimum, new if type(new) == 'number'
            def: 0

with i = INFLUENCE!
    print .amount
    .amount = 1
    print .amount
    .amount -= 2
    print .amount
    .amount += 5
    print .amount

SYNCLASS