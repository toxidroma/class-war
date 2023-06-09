--using ENTITY class to define a SENT

--NOTE: the name the SENT is registered is normally the name of the file/folder that defines it
    --if you wanted to use GMod's restrictive, awful mechanism for SENT definition built into it, you won't need this class at all
        --unlike GMod's frustrating default SENT creation method, 
        --the ENTITY class can be extended from any code anywhere within a package that requires this package (class-war)
        --you can do this as many times as you want and organize it however you'd like (currently, only within the confines of a package; this might change)
    --AS A RESULT: there are no file/folder names that can be used to create the entity's internal name
    --you MUST do either of the following to give your entity an internal name, which is a requirement for your entity to be registered and usable
        --class <name> extends ENTITY
    --OR
        --@__entity: <name>
            --MUST be a string
    --you can do both of these if you want
        --this allows you to access the name you put after 'class' and before 'extends' as a variable which refers to that class object
        --however, what you put in @__entity is what your SENT is registered with regardless of the class object's name/lack of one
    --which means:

        --class Grenade extends ENTITY
            --...a SENT is registered as 'grenade'
            --...variable 'Grenade' exists and points to the new class object Grenade
            --...perfectly serviceable method

        --class extends ENTITY
        --  @__entity: 'Grenade'
            --...a SENT is registered as 'grenade'
            --...a name is not set after 'class', so you cannot extend this class easily
            --...this method is NOT RECOMMENDED
    
        --class Grenade extends ENTITY
        --  @__entity 'Grenade'
            --...a SENT is registered as 'grenade'
                --changing @__entity to another string will register it with that new string as its name
            --...in the same environment, 'Grenade' is still the variable that points to the class object
                --regardless of @__entity's value or whether @__entity is set
            --...perfectly serviceable method
                --...but your class name is going to become the same as your class's @__entity value after being made lowercase
                    --you might as well not include the field @__entity

--NOTE: however you name your entity, it
    --...will be made lowercase
    --...will be fixed with a 'lineage' of your descending ENTITY class's inheritance
        --the lineage begins just after ENTITY
    --which means:

    --class extends Grenade
    --  @__entity: 'INCENDIARY'
        --...a SENT is registered as 'grenade/incendiary'
        --...all field definitions on Grenade are inherited by grenade/incendiary
        --...this can't extend further unless 'class extends Grenade' is assigned to a variable somewhere

    --class Incendiary extends Grenade
        --...a SENT is registered as 'grenade/incendiary'
        --...all field definitions on Grenade are inherited by SENT grenade/incendiary
            --therefore any fields on Grenade that don't get defined as something else on Incendiary
            --are set on grenade/incendiary to the value of the same field on Grenade
        --...you can extend from Incendiary to inherit deeper

    --class Impact extends Incendiary
        --...a SENT is registered as 'grenade/incendiary/impact'
        --...as with Incendiary extending Grenade, grenade/incendiary/impact inherits everything it doesn't set by itself to corresponding data of Incendiary
            --this continues in ascending order through the lineage, so:
                --grenade/incendiary/impact will first inherit from grenade/incendiary
                --grenade/incendiary inherits from grenade, so grenade/incendiary/impact will inherit from grenade after inheriting from grenade/incendiary

import GetSurfaceData, TraceLine from util

--FINALLY, some working examples:
    --bomb
class Bomb extends ENTITY
    Base: 'base_gmodentity'
    Model: Model 'models/props_junk/PopCan01a.mdl'
    Category: 'class-war.examples'
    Spawnable: true

    Damage: 175
    Radius: 250

    Initialize: =>
        @SetModel @Model
        if SERVER
            @PhysicsInit SOLID_VPHYSICS
            @SetMoveType MOVETYPE_VPHYSICS
            @SetUseType SIMPLE_USE
        @PhysWake!
    Use: (ply) => 
        return if @IsPlayerHolding!
        ply\PickupObject @
        pos = @GetPos!
        tr = TraceLine 
            start: pos
            endpos: pos
        surfprop = GetSurfaceData tr.SurfaceProps
        surfprop or= GetSurfaceData 0
        @EmitSound surfprop.impactSoftSound
    Detonate: => 
        pos = @WorldSpaceCenter!
        util.ScreenShake pos, 25, 150, 1, @Radius
        with ents.Create 'env_explosion'
            \SetOwner @GetOwner!
            \SetPos pos
            \SetKeyValue 'iMagnitude', @Damage
            \SetKeyValue 'iRadiusOverride', @Radius
            \Spawn!
            \Activate!
            \Fire 'Explode'
        @Remove!
    PhysicsCollide: (data) => @EmitSound 'SolidMetal.ImpactHard' if data.Speed > 64

import Trim from string
--the below creates a SENT which is almost an exact copy of bomb, except it has a new model and it will explode if it smacks against something hard enough
    --bomb/unstable
class Unstable extends Bomb
    Model: Model 'models/Items/combine_rifle_ammo01.mdl'
    ImpactThreshold: 256
    GetOverlayText: => "explodes on impact at speed > #{@ImpactThreshold}"
    PhysicsCollide: (data) =>
        super data  --what does this do?
                --it runs the PhysicsCollide function from its parent while passing itself as the first argument (@, or 'self')
            --the PhysicsCollide function on the parent Bomb emits the sound SolidMetal.ImpactHard if it collides at speed > 32
        --as a result, so will bomb/unstable, and after it does that we want it to explode:
        @Detonate! if data.Speed > @ImpactThreshold

--same inheritance principles
    --bomb/unstable/sensitive
class Sensitive extends Unstable
    ImpactThreshold: 128

--below bomb explodes the moment it touches a player
class Landmine extends Bomb
    Model: Model 'models/props_junk/cardboard_box004a.mdl'
    GetOverlayText: => 'explodes when touched by a player'
    StartTouch: (ent) => 
        @Detonate! if ent\IsPlayer! 

-- below is an entity that burns after being shot and then explodes, or explodes after @MaxHits shots
class Canister extends Bomb
    Damage: 125
    Model: Model 'models/props_c17/canister01a.mdl'
    Hits: 0
    MaxHits: 3
    BurnTime: 4
    GetOverlayText: => "explodes after:\nfirst shot at #{@BurnTime}s\nor after #{@MaxHits} shots"
    OnTakeDamage: (dmg) =>
        if not dmg\IsBulletDamage! return
        @Hits += 1
        if @Hits == 1
            @Ignite @BurnTime
            timer.Simple @BurnTime, -> 
                @Detonate! if @IsValid! 
        elseif @Hits >= @MaxHits 
            @Detonate!

import random from math

incendiaryGibs = {
    Model 'models/props_c17/canisterchunk02a.mdl'
    Model 'models/props_c17/canisterchunk02d.mdl'
    Model 'models/props_c17/canisterchunk02h.mdl'
    Model 'models/props_c17/canisterchunk02m.mdl'
    Model 'models/props_c17/canisterchunk02b.mdl'
}

class Incendiary extends Canister
    Damage: 25
    Model: Model 'models/props_c17/canister02a.mdl'
    Detonate: =>
        owner, pos = @GetOwner!, @WorldSpaceCenter!
        super!
        for i = 1, random(5, 6)
            with ents.Create 'prop_physics'
                \SetOwner owner
                \SetPos pos + Vector(0,0,64)
                \SetAngles Angle( random( 0, 360 ), random( 0, 360 ), random( 0, 360 ) )
                \SetModel table.Random incendiaryGibs
                \Spawn!
                \Activate!
                \Ignite random(8, 10), 100
                timer.Simple random(11, 22), -> 
                    \Remove! if \IsValid! 