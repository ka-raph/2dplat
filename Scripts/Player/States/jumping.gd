extends PlayerState

func Enter() -> void:
	player.velocity.y = -player.jump_impulse
	player.sprite.play("jump")

func Physics_Update(delta: float) -> void:
	player.movement_component.handle_horizontal_movement(delta)

	if player.is_hurt and not player.is_recovering:
		Transition(self, HURT)
	elif player.input_component.get_attack1_input():
		Transition(self, ATTACK1)
	elif player.input_component.get_parry_input():
		Transition(self, PARRY)
	elif player.velocity.y >= 0:
		Transition(self, FALLING)
	elif player.input_component.get_attack1_input():
		Transition(self, ATTACK1)
