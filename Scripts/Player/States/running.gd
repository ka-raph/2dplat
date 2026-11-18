extends PlayerState

func Enter() -> void:
	player.sprite.play("run")

func Physics_Update(_delta: float) -> void:
	if try_action_transitions():
		return
	try_movement_transitions()
