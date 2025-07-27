extends PlayerState

func Enter() -> void:
	player.sprite.play("run")

func Physics_Update(delta: float) -> void:
	if player.is_attacking:
		return

	var input_direction_x := Input.get_axis("move_left", "move_right")
	player.velocity.x = player.speed * input_direction_x
	player.velocity.y += player.gravity * delta
	handle_horizontal_flip(input_direction_x)
	player.move_and_slide()

	if not player.is_on_floor():
		Transitioned.emit(self, FALLING)
	elif Input.is_action_just_pressed("attack1"):
		Transitioned.emit(self, ATTACK1)
	elif Input.is_action_just_pressed("jump"):
		Transitioned.emit(self, JUMPING)
	elif is_equal_approx(input_direction_x, 0.0):
		Transitioned.emit(self, IDLE)

func handle_horizontal_flip(move_direction: float) -> void:
	if move_direction == 0:
		return
		
	player.sprite.flip_h = false if move_direction > 0 else true
	player.emit_signal("facing_direction_changed", !player.sprite.flip_h)
