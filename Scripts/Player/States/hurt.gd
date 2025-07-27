extends PlayerState

func Enter() -> void:
	player.sprite.play("hurt")
	player.is_hurt = true
	player.health -= 20
	print("Player hur, health: " + str(player.health))

func Physics_Update(delta: float) -> void:
	player.velocity.x = player.push_direction * 100
	player.velocity.y = -100
	player.move_and_slide()
	
	if player.is_hurt:
		return
	elif not player.is_on_floor():
		Transition(self, FALLING)
	elif player.input_component.get_attack1_input():
		Transition(self, ATTACK1)
	elif player.input_component.get_jump_input():
		Transition(self, JUMPING)
	elif not is_equal_approx(player.input_component.get_input_direction_x(), 0.0):
		Transition(self, RUNNING)
	else:
		Transition(self, IDLE)
