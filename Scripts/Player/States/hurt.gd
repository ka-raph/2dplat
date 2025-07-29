extends PlayerState
@export var recover_cooldown: Timer

func Enter() -> void:
	if recover_cooldown.is_stopped():
		recover_cooldown.start()
	player.sprite.play("hurt")
	player.is_hurt = true
	player.hit(15)
	print("Player hurt, health: " + str(player.health))

func Physics_Update(delta: float) -> void:
	player.velocity.x = player.push_direction.x * recover_cooldown.time_left * 1000
	player.velocity.y = player.push_direction.y * recover_cooldown.time_left * 1000
	player.move_and_slide()
	
	if player.is_hurt or not recover_cooldown.is_stopped():
		return
	elif not player.is_on_floor():
		Transition(self, FALLING)
	elif player.input_component.get_attack1_input():
		Transition(self, ATTACK1)
	elif player.input_component.get_parry_input():
		Transition(self, PARRY)
	elif player.input_component.get_jump_input():
		Transition(self, JUMPING)
	elif not is_equal_approx(player.input_component.get_input_direction_x(), 0.0):
		Transition(self, RUNNING)
	else:
		Transition(self, IDLE)
