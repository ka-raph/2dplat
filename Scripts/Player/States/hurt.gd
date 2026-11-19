extends PlayerState

# Knockback is applied once on Enter, then MovementComponent's friction slows it down.
func Enter() -> void:
	player.animation.play("hurt")
	player.velocity = player.last_knockback
	player.movement_component.control_enabled = false

func Physics_Update(_delta: float) -> void:
	if player.health.is_dead():
		Transition(self, DEATH)
	elif player.is_hurt or not player.is_recovering:
		return
	elif not try_action_transitions():
		try_movement_transitions()

func Exit() -> void:
	player.movement_component.control_enabled = true
