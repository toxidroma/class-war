import Register from weapons
import lower, Left from string
import TraceLine from util
logger  = _PKG\GetLogger!
gm      = gmod.GetGamemode!
class
    @__inherited: (child) =>
        with getmetatable child
            .__call = (where, ...) => 
                local ent
                if isvector where
                    ent = Create @__barcode
                    ent\SetPos where
                    ent\Spawn!
                elseif isentity(where) and where\IsPlayer!
                    ent = where\Give @__barcode
                ent.__class = ent.BaseClass
                @.__init ent, ...
                ent
        fields = {k,v for k,v in pairs(child.__base) when Left(k, 2) != "__"}
        fields.Base or= @__barcode
        fields.Spawnable or= @Spawnable
        fields.Category or= @Category
        child.__barcode = "#{@__barcode and @__barcode .. '/' or ''}#{lower(rawget(child, '__weapon') or child.__name)}"
        Register fields, child.__barcode
        logger\Debug "+WEAPON: #{child.__barcode}"
        if CLIENT and gm.IsSandboxDerived and child.Spawnable
            timer.Create tostring(_PKG), 1, 1, ->
                logger\Debug 'Reloading the spawnmenu.'
                RunConsoleCommand 'spawnmenu_reload'
    new: => @SetHoldType 'pistol'