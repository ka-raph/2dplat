extends PlayerState

func Enter() -> void:
	player.sprite.play("fall")

func Physics_Update(delta: float) -> void:
	if player.is_attacking:
		return

	var input_direction_x: float = player.movement_component.handle_horizontal_movement(delta)

	if player.health <= 0:
		Transition(self, DEATH)
	elif player.is_enemy_in_attack_range:
		Transition(self, HURT)
	elif Input.is_action_just_pressed("attack1"):
		Transition(self, ATTACK1)
	if player.is_on_floor():
		if is_equal_approx(input_direction_x, 0.0):
			Transition(self, IDLE)
		else:
			Transition(self, RUNNING)
