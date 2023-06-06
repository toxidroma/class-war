return unless CLIENT
import Create, Register, GetControlTable from vgui
import lower, Left from string
logger  = _PKG\GetLogger!
class
    @__inherited: (child) =>
        with getmetatable child
            .__call = (...) => 
                panel = Create @__barcode
                panel.__class = GetControlTable @__barcode
                @.__init panel, ...
                panel
        fields = {k,v for k,v in pairs(child) when Left(k, 2) != "__"}
        base = fields.Base or @__barcode
        fields.Base = nil
        child.__barcode = "#{@__barcode and @__barcode .. '/' or ''}#{lower child.__name}"
        Register child.__barcode, fields, base
        logger\Debug "+VGUI: #{child.__barcode}"
    new: (x=0, y=0, w=256, h=128) => 
        @SetPos x, y
        @SetSize w, h