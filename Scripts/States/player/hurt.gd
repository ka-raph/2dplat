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
		Transitioned.emit(self, FALLING)
	elif Input.is_action_just_pressed("attack1"):
		Transitioned.emit(self, ATTACK1)
	elif Input.is_action_just_pressed("jump"):
		Transitioned.emit(self, JUMPING)
	elif Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		Transitioned.emit(self, RUNNING)
	else:
		Transitioned.emit(self, IDLE)
