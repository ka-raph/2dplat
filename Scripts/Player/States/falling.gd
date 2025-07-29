extends PlayerState

func Enter() -> void:
	player.sprite.play("fall")

func Physics_Update(delta: float) -> void:
	var input_direction_x: float = player.movement_component.handle_horizontal_movement(delta)

	if player.is_enemy_in_attack_range:
		Transition(self, HURT)
	elif player.input_component.get_attack1_input():
		Transition(self, ATTACK1)
	elif player.input_component.get_parry_input():
		Transition(self, PARRY)
	if player.is_on_floor():
		if is_equal_approx(input_direction_x, 0.0):
			Transition(self, IDLE)
		else:
			Transition(self, RUNNING)
