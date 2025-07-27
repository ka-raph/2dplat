extends PlayerState

func Enter() -> void:
	player.sprite.play("attack1")
	player.is_attacking = true

func Physics_Update(delta: float) -> void:
	var input_direction_x := Input.get_axis("move_left", "move_right")
	player.velocity.x = player.speed * input_direction_x
	player.velocity.y += player.gravity * delta
	player.move_and_slide()
	
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
	player.emit_signal("facing_direction_changed", player.sprite.flip_h)
