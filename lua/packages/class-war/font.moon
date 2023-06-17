return unless CLIENT
import CreateFont from surface
import lower, sub from string
logger  = _PKG\GetLogger!
class
    @__inherited: (child) =>
        fields = {}
        ancestor = child
        while ancestor
            inheritance = {k,v for k,v in pairs ancestor.__base when not fields[k] and k != 'new' and sub(k,1,2) != '__'}
            fields[k] = v for k,v in pairs inheritance
            break unless ancestor.__parent
            ancestor = ancestor.__parent
        child.__barcode = "#{@__barcode and @__barcode .. '/' or ''}#{lower child.__name}"
        CreateFont child.__barcode, fields
        logger\Debug "+FONT: #{child.__barcode}"
    font: 'Arial'
    extended: false
    size: 13
    weight: 500
    blursize: 0
    antialias: true
    underline: false
    italic: false
    strikeout: false
    symbol: false
    rotary: false
    shadow: false
    additive: false
    outline: false