import \Punch from require 'vpunch-local', 'https://github.com/toxidroma/vpunch-local'
class Gun extends WEAPON
    @Category: 'class-war.examples'
    @Spawnable: true
    @UseHands: true
    @AccurateCrosshair: true
    @CanPrimaryAttack: => true unless (@Clip1! <= 0) or (@GetNextPrimaryFire! >= CurTime!)
    @PrimaryAttack: =>
        if @CanPrimaryAttack!
            @EmitSound @Primary.Sound
            @ShootBullet @Primary.Damage, 1, .01
            @TakePrimaryAmmo 1
            @SetNextPrimaryFire CurTime! + @Primary.Delay
            true
    @CanSecondaryAttack: => true unless (@Clip2! <= 0) or (@GetNextSecondaryFire! >= CurTime!)
    @SecondaryAttack: =>
        if @CanSecondaryAttack!
            @EmitSound @Secondary.Sound
            @ShootBullet @Secondary.Damage, 1, .01
            @TakeSecondaryAmmo 1

import random from math
class Pistol extends Gun
    @WorldModel: Model 'models/weapons/w_pistol.mdl'
    @ViewModel: Model 'models/weapons/c_pistol.mdl'
    @PrimaryAttack: =>
        if super!
            Punch Angle random(-1,-3), random(-2,2), random(-1,1) if CLIENT
    @Primary:
        Ammo:           'Pistol'
        ClipSize:       18
        DefaultClip:    36
        Damage:         13
        Delay:          60 / 600
        Sound:          'Weapon_Pistol.Single'

class Auto extends Pistol
    @Primary:
        Ammo:           'Pistol'
        ClipSize:       18
        DefaultClip:    36
        Damage:         13
        Delay:          60 / 600
        Sound:          'Weapon_Pistol.Single'
        Automatic:      true