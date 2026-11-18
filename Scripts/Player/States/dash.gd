extends PlayerState

func Enter() -> void:
	player.is_dashing = true
	player.animation.play("dash")

	var input_direction := player.input_component.get_input_direction_x()
	if input_direction == 0:
		input_direction = 1.0 if not player.sprite.flip_h else -1.0

	player.movement_component.handle_dashing(input_direction)
	player.dashed.emit() # Signal for if we use say a rune system on dash (something happens) Can be removed otherwise

func Physics_Update(_delta: float) -> void:
	if player.is_dashing:
		return
	if try_action_transitions():
		return
	try_movement_transitions()

func Exit() -> void:
	player.is_dashing = false
