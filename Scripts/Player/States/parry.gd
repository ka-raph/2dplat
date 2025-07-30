extends PlayerState

func Enter() -> void:
	player.sprite.play("parry")
	player.is_parrying = true

func Physics_Update(delta: float) -> void:
	var input_direction_x: float = player.movement_component.handle_horizontal_movement(delta, true)
	
	if player.is_parrying:
		return
	elif player.is_hurt:
		Transition(self, HURT)
	elif player.input_component.get_attack1_input():
		Transition(self, ATTACK1)
	elif player.input_component.get_parry_input():
		Transition(self, PARRY)
	elif not player.is_on_floor():
		Transition(self, FALLING)
	elif player.input_component.get_jump_input():
		Transition(self, JUMPING)
	elif not is_equal_approx(input_direction_x, 0.0):
		Transition(self, RUNNING)
	else:
		Transition(self, IDLE)
