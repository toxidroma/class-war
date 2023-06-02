return unless CLIENT
export CIRCLE_FILLED, CIRCLE_OUTLINED, CIRCLE_BLURRED = 0, 1, 2
import NoTexture from draw
import ClearStencil, SetStencilEnable, UpdateScreenEffectTexture,
    SetStencilCompareFunction, SetStencilTestMask, SetStencilWriteMask,
    SetStencilReferenceValue, SetStencilFailOperation, SetStencilZFailOperation from render
import SetMaterial, SetDrawColor, 
    DrawPoly, DrawTexturedRect from surface
import insert, remove, Copy from table
blur = Material 'pp/blurscreen'
class
    new: (type, radius, x, y, ...) => 
        @SetType type
        @SetRadius radius
        @SetX x
        @SetY y
        @vertices = {}
        switch @type
            when CIRCLE_OUTLINED
                @outlineWidth = ...
            when CIRCLE_BLURRED
                @blurLayers, @blurDensity = ...
        @recalc = true
        @shouldRender = true
        @startAngle, @endAngle = 0, 360
        @rotation = 0
        @distance = 10
        @color = color_white
        @mat = true
        @matRotate = false
    SetType: (@type) => @recalc = true
    SetRadius: (@radius) => @recalc = true
    SetRotation: (rot) => 
        old = @rotation
        @rotation = rot
        @UpdateRotation old, @rotation
    Rotate: (rot) =>
        return if rot == 0
        @rotation += rot
        return unless @IsValid!
        @RotateVertices!
        if @child and @type == CIRCLE_OUTLINED
            @child\Rotate rot
    UpdateRotation: (old, new) => 
        rot = new - old
        @RotateVertices rot
        if @type == CIRCLE_OUTLINED and @child
            @child\UpdateRotation old, new
    IsValid: => (not @recalc and #@vertices >= 3 and @radius >= 1 and @distance >= 1)
    Translate: (x, y) =>
        return if x == 0 and y == 0
        @x += x
        @y += y
        return unless @IsValid!
        for vert in *@vertices
            with vert
                .x += x
                .y += y
        if @child and @type == CIRCLE_OUTLINED
            @child\Translate x, y
    SetX: (x) =>
        old = @x 
        @x = x
        @OffsetVerticesX old, @x
    OffsetVerticesX: (old, new) =>
        return unless @IsValid!
        @Translate new, old, 0
        if @type == CIRCLE_OUTLINED and @child
            @child\OffsetVerticesX old, new
        return new
    SetY: (y) =>
        old = @y 
        @y = y
        @OffsetVerticesY old, @y
    OffsetVerticesY: (old, new) =>
        return unless @IsValid!
        @Translate new, old, 0
        if @type == CIRCLE_OUTLINED and @child
            @child\OffsetVerticesY old, new
        return new
    SetPos: (x=0, y=0) => @Translate x - @x, y - @y    
    SetAngles: (s, e) =>
        @recalc = @recalc or s != @startAngle or e != @endAngle
        @startAngle, @endAngle = s, e
    GetPos: => @x, @y
    GetAngles: => @startAngle, @endAngle
    Copy: => Copy @
    RotateVertices: (rot) =>
        rot = math.rad rot
        c = math.cos rot
        s = math.sin rot
        for vertex in *@vertices
            vx, vy = vertex.x, vertex.y
            vx -= @x
            vy -= @y
            vertex.x = @x + (vx * c - vy * s)
            vertex.y = @y + (vx * s + vy * c)
            unless @matRotate
                u, v = vertex.u, vertex.v 
                u -= .5
                v -= .5
                vertex.u = .5 + (u * c - v * s)
                vertex.v = .5 + (u * s + v * c)
    CalculateVertices: =>
        @vertices = {}
        step = @distance / @radius
        radStartAngle = math.rad @startAngle
        radEndAngle = math.rad @endAngle
        radRotation = math.rad @rotation
        for a = radStartAngle, radEndAngle + step, step do
            a = math.min a, radEndAngle
            c, s = math.cos(a + radRotation), math.sin(a + radRotation)
            vertex = 
                x: @x + c * @radius
                y: @y + s * @radius
            if @matRotate == false
                vertex.u = .5 + math.cos(a) / 2
                vertex.v = .5 + math.sin(a) / 2
            else
                vertex.u = .5 + c / 2
                vertex.v = .5 + s / 2
            @vertices[#@vertices + 1] = vertex
        if @endAngle - @startAngle != 360
            insert @vertices, 1, {
                x: @x
                y: @y
                u: .5
                v: .5
            }
        else
            remove @vertices
        return @vertices
    Calculate: =>
        @CalculateVertices!
        if @type == CIRCLE_OUTLINED
            inner = @child or @Copy!
            r = @radius - @outlineWidth
            if r >= @radius
                @shouldRender = false
            else
                if r >= 1
                    inner\SetAngles @startAngle, @endAngle
                    inner.type = CIRCLE_FILLED
                    inner.radius = r
                    inner.color = false
                    inner.mat = false
                    inner.shouldRender = true
                else
                    inner.shouldRender = false
                @shouldRender = true
            @child = inner
        elseif @child
            @child = nil
        @recalc = false
   
    Draw: =>
        @Calculate! if @recalc
        return false unless @shouldRender and @IsValid!

        if IsColor @color
            return unless @color.a > 0
            SetDrawColor @color.r, @color.g, @color.b, @color.a

        if @mat == true
            NoTexture!
        elseif TypeID(@mat) == TYPE_MATERIAL
            SetMaterial @mat

        switch @type
            when CIRCLE_OUTLINED
                ClearStencil!
                SetStencilEnable true
                SetStencilTestMask(0xFF)
                SetStencilWriteMask(0xFF)
                SetStencilReferenceValue(0x01)

                SetStencilCompareFunction STENCIL_NEVER
                SetStencilFailOperation STENCIL_REPLACE
                SetStencilZFailOperation STENCIL_REPLACE

                @child\Draw!

                SetStencilCompareFunction STENCIL_GREATER
                SetStencilFailOperation STENCIL_KEEP
                SetStencilZFailOperation STENCIL_KEEP

                DrawPoly @vertices
                SetStencilEnable false
            when CIRCLE_BLURRED
                ClearStencil!
                SetStencilEnable true

                SetStencilTestMask(0xFF)
                SetStencilWriteMask(0xFF)
                SetStencilReferenceValue(0x01)

                SetStencilCompareFunction STENCIL_NEVER
                SetStencilFailOperation STENCIL_REPLACE
                SetStencilZFailOperation STENCIL_REPLACE

                DrawPoly @vertices

                SetStencilCompareFunction STENCIL_LESSEQUAL
                SetStencilFailOperation STENCIL_KEEP
                SetStencilZFailOperation STENCIL_KEEP

                SetMaterial blur

                sw, sh = ScrW!, ScrH!
                for i = 1, @blurLayers
                    blur\SetFloat "$blur", (i / @blurLayers) * @blurDensity
                    blur\Recompute!

                    UpdateScreenEffectTexture!
                    DrawTexturedRect 0, 0, sw, sh
                SetStencilEnable false
            else
                DrawPoly @vertices

        return true