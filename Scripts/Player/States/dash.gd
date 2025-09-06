extends PlayerState

func Enter() -> void:
	player.sprite.play("dash")
	
	var input_direction = player.input_component.get_input_direction_x()
	if input_direction == 0:
		input_direction = 1 if not player.sprite.flip_h else -1
	
	if not player.has_just_dashed:
		player.movement_component.handle_dashing(input_direction)
		player.has_just_dashed = true

func Physics_Update(delta: float) -> void:
	if player.is_hurt and not player.is_recovering:
		Transition(self, HURT)
	elif not player.is_on_floor():
		Transition(self, FALLING)
	elif player.input_component.get_attack1_input():
		Transition(self, ATTACK1)
	elif player.input_component.get_parry_input():
		Transition(self, PARRY)
	elif player.velocity.y < 0:
		Transition(self, JUMPING)
	elif is_equal_approx(player.velocity.x, 0.0):
		Transition(self, IDLE)
