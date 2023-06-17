import PrecacheSound from util

export ^
SNDLVL_NONE = 0
SNDLVL_20dB = 20 --rustling leaves
SNDLVL_25dB = 25 --whispering
SNDLVL_30dB = 30 --library
SNDLVL_35dB = 35
SNDLVL_40dB = 40
SNDLVL_45dB = 45 --refrigerator
SNDLVL_50dB = 50 --average home
SNDLVL_55dB = 55
SNDLVL_IDLE = 60
SNDLVL_60dB = 60 --normal conversation, clothes dryer
SNDLVL_65dB = 65 --washing machine, dishwasher
SNDLVL_STATIC = 66
SNDLVL_70dB = 70 --car, vacuum cleaner, mixer, electric sewing machine
SNDLVL_NORM = 75
SNDLVL_75dB = 75 --busy traffic
SNDLVL_80dB = 80 -- mini-bike, alarm clock, noisy restaurant, office tabulator, outboard motor, passing snowmobile
SNDLVL_TALKING = 80
SNDLVL_85dB = 85 --average factory, electric shaver
SNDLVL_90dB = 90 --screaming child, passing motorcycle, convertible ride on frw
SNDLVL_95dB = 95
SNDLVL_100dB = 100 --subway train, diesel truck, woodworking shop, pneumatic drill, boiler shop, jackhammer
SNDLVL_105dB = 105 --helicopter, power mower
SNDLVL_110dB = 110 --snowmobile drvrs seat, inboard motorboat, sandblasting
SNDLVL_120dB = 120 --auto horn, propeller aircraft
SNDLVL_130dB = 130 --air raid siren
SNDLVL_GUNFIRE = 140 --THRESHOLD OF PAIN, gunshot, jet engine
SNDLVL_140dB = 140
SNDLVL_150dB = 150
SNDLVL_180dB = 180 --rocket launching

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
    new: (where) =>
        
    channel: CHAN_AUTO
    level: SNDLVL_NORM
    volume: 1
    pitch: {95, 105}
    sound: {}