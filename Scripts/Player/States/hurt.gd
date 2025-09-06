extends PlayerState
@export var recover_cooldown: Timer

var push_acceleration: float

func Enter() -> void:
	push_acceleration = 0.5
	player.animation.play("hurt")

func Physics_Update(delta: float) -> void:
	push_acceleration += delta
	player.velocity.x = player.push_direction.x * 100 / push_acceleration
	player.velocity.y = player.push_direction.y * 100 / push_acceleration
	
	# The is_hurt state is exited as soon as the player is recovering and re-toggled after recovery if necessary
	if player.health == 0:
		Transition(self, DEATH)
	elif player.is_hurt or not player.is_recovering:
		return
	elif not player.is_on_floor():
		Transition(self, FALLING)
	elif player.input_component.get_attack1_input():
		Transition(self, ATTACK1)
	elif player.input_component.get_parry_input():
		Transition(self, PARRY)
	elif player.input_component.get_dash_input() and player.dash_cooldown == 2.0:
		Transition(self, DASH)
	elif player.velocity.y < 0:
		Transition(self, JUMPING)
	elif not is_equal_approx(player.velocity.x, 0.0):
		Transition(self, RUNNING)
	else:
		Transition(self, IDLE)
