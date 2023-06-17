return unless CLIENT
import Create, Register, GetControlTable from vgui
import lower, Left from string
logger  = _PKG\GetLogger!
class
    Width: 320
    Height: 200

    @__inherited: (child) =>
        with getmetatable child
            .__call = (...) => 
                panel = Create @__barcode
                panel.__class = @
                panel[k] = v for k,v in pairs(@__base) when Left(k, 2) != "__"
                @.__init panel, ...
                panel
        fields = {k,v for k,v in pairs(child.__base) when Left(k, 2) != "__"}
        fields.__name = child.__name
        base = fields.Base or @__barcode
        fields.Base = nil
        child.__barcode = "#{@__barcode and @__barcode .. '/' or ''}#{lower child.__name}"
        Register child.__barcode, fields, base
        logger\Debug "+VGUI: #{child.__barcode}"
    new: (x=ScrW!/2, y=ScrH!/2) => 
        @SetPos x, y
        @SetSize @Width, @Height