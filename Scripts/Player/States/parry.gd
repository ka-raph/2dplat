extends PlayerState

func Enter() -> void:
	player.animation.play("parry")
	player.is_parrying = true

func Physics_Update(delta: float) -> void:
	# TODO hurt + parry (but not perfect) should we still make the player sprite flash but don't push the player away??
	# TODO if player.is_parrying and not player.is_perfect_parry:
		
	if player.is_parrying and not player.is_hurt and not player.is_recovering:
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
