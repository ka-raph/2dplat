extends PlayerState

func Enter() -> void:
	player.sprite.play("idle")

func Physics_Update(_delta: float) -> void:
	player.velocity.y += player.movement_component.gravity * _delta

	if player.is_hurt and not player.is_recovering:
		Transition(self, HURT)
	elif not player.is_on_floor():
		Transition(self, FALLING)
	elif player.input_component.get_attack1_input():
		Transition(self, ATTACK1)
	elif player.input_component.get_parry_input():
		Transition(self, PARRY)
	elif player.velocity.y < 0.0:
		Transition(self, JUMPING)
	elif not is_equal_approx(player.velocity.x, 0.0):
		Transition(self, RUNNING)
