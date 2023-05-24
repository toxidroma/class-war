class
	@CONTROLS: {}
	IsDown: (ply) =>
		if SERVER
			return @state[ply]
		else
			return @state
	new: (@control, @key, extra) =>
		with extra
			@press 		= .Press or =>
			@release 	= .Release or =>
			@think 		= .Think or =>
		if CLIENT
			@state = false
		else
			@state = {}
		hook.Add 'PlayerButtonDown', _PKG\GetIdentifier('bind:'..@control), (ply, key) ->
			return unless IsFirstTimePredicted!
			return unless key == @key
			if SERVER
				return if @state[ply]
				@state[ply] = true
			else
				return if @state
				@state = true
			@press ply
			return
        hook.Add 'PlayerButtonUp', _PKG\GetIdentifier('bind:'..@control), (ply, key) ->
			return unless IsFirstTimePredicted!
			return unless key == @key
			if SERVER
				return unless @state[ply]
				@state[ply] = false
			else
				return unless @state
				@state = false
			@release ply
			return
        hook.Add 'PostPlayerThink', _PKG\GetIdentifier('bind:'..@control), (ply) -> 
			if SERVER
				@think ply if @state[ply]
			else
				@think ply if @state
			return
		@@CONTROLS[@control] = @