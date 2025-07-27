extends PlayerState

func Enter() -> void:
	player.velocity.x = 0.0
	player.sprite.play("idle")

func Physics_Update(_delta: float) -> void:
	if player.is_attacking:
		return

	player.velocity.y += player.gravity * _delta
	player.move_and_slide()

	if player.is_enemy_in_attack_range:
		Transition(self, HURT)
	elif not player.is_on_floor():
		Transition(self, FALLING)
	elif player.input_component.get_attack1_input():
		Transition(self, ATTACK1)
	elif player.input_component.get_jump_input():
		Transition(self, JUMPING)
	elif not is_equal_approx(player.input_component.get_input_direction_x(), 0.0):
		Transition(self, RUNNING)
