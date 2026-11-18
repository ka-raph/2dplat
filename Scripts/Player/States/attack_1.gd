extends PlayerState

@export var move_multiplier: float = 0.2

func Enter() -> void:
	player.animation.play("attack1")
	player.is_attacking = true
	player.sword.begin_swing()
	player.movement_component.speed_multiplier = move_multiplier
	player.movement_component.can_turn = false

func Physics_Update(_delta: float) -> void:
	# Should we cancel the attack or just damage the player with visual feedback, like red flashing?
	if player.is_attacking:
		if player.dash_cooldown.is_stopped() and player.input_component.consume(&"dash"):
			Transition(self, DASH)
		return

	if try_action_transitions():
		return
	try_movement_transitions()

func Exit() -> void:
	player.is_attacking = false
	player.sword.set_deferred("monitoring", false)
	player.movement_component.speed_multiplier = 1.0
	player.movement_component.can_turn = true
