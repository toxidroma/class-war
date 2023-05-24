import PrecacheSound from util
class
    @__inherited: (child) =>
        snd = 
            name: child.__name
        ancestor = child
        while ancestor
            for k, v in pairs ancestor.__base
                continue if string.sub(k,1,2) == "__"
                snd[k] = v unless snd[k]
            break unless ancestor.__parent
            ancestor = ancestor.__parent
        if istable snd.sound
            PrecacheSound s for s in *snd.sound
        else
            PrecacheSound snd.sound
        sound.Add snd
    channel: CHAN_AUTO
    level: SNDLVL_NORM
    volume: 1
    pitch: {95, 105}
    sound: {}