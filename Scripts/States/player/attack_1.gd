extends PlayerState

func Enter() -> void:
	player.sprite.play("attack1")
	player.is_attacking = true

func Physics_Update(delta: float) -> void:
	if player.is_attacking:
		return
	if not player.is_on_floor():
		Transitioned.emit(self, FALLING)
	elif Input.is_action_just_pressed("jump"):
		Transitioned.emit(self, JUMPING)
	elif  Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		Transitioned.emit(self, RUNNING)
	else:
		Transitioned.emit(self, IDLE)

func handle_horizontal_flip(move_direction: float) -> void:
	if move_direction == 0:
		return
		
	player.sprite.flip_h = false if move_direction > 0 else true
