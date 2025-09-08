extends PlayerState

func Enter() -> void:
	player.sprite.play("jump")

func Physics_Update(delta: float) -> void:
	if player.is_hurt and not player.is_recovering:
		Transition(self, HURT)
	elif player.input_component.get_attack1_input():
		Transition(self, ATTACK1)
	elif player.input_component.get_parry_input():
		Transition(self, PARRY)
	elif player.input_component.get_dash_input() and player.dash_cooldown.is_stopped():
		Transition(self, DASH) # Want to dash while jumping??
	elif player.velocity.y >= 0:
		Transition(self, FALLING)
	elif player.input_component.get_attack1_input():
		Transition(self, ATTACK1)
