extends PlayerState

func Enter() -> void:
	player.animation.play("parry")
	player.is_parrying = true

func Physics_Update(_delta: float) -> void:
	# TODO Should we make the player sprite flash or push the player away??
	if player.is_parrying and not player.is_hurt and not player.is_recovering:
		return
	# we couldn't dash after parry, so made that possible
	if try_action_transitions():
		return
	try_movement_transitions()

func Exit() -> void:
	player.is_parrying = false
	player.is_perfect_parry = false
