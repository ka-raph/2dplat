extends PlayerState

func Enter() -> void:
	player.animation.play("attack1")
	player.is_attacking = true

func Physics_Update(delta: float) -> void:	
	# Should we cancel the attack or just damage the player with visual feedback (red flashing)?
	if player.is_attacking:
		return
	elif player.is_hurt and not player.is_recovering:
		Transition(self, HURT)
	elif player.input_component.get_attack1_input():
		Transition(self, ATTACK1)
	elif player.input_component.get_parry_input():
		Transition(self, PARRY)
	elif not player.is_on_floor():
		Transition(self, FALLING)
	elif player.velocity.y < 0:
		Transition(self, JUMPING)
	elif not is_equal_approx(player.velocity.x, 0.0):
		Transition(self, RUNNING)
	else:
		Transition(self, IDLE)
