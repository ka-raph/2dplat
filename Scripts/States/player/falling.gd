extends PlayerState

func Enter() -> void:
	player.sprite.play("fall")

func Physics_Update(delta: float) -> void:
	if player.is_attacking:
		return

	var input_direction_x := Input.get_axis("move_left", "move_right")
	player.velocity.x = player.speed * input_direction_x
	player.velocity.y += player.gravity * delta
	handle_horizontal_flip(input_direction_x)
	player.move_and_slide()


	if Input.is_action_just_pressed("attack1"):
		Transitioned.emit(self, ATTACK1)
	if player.is_on_floor():
		if is_equal_approx(input_direction_x, 0.0):
			Transitioned.emit(self, IDLE)
		else:
			Transitioned.emit(self, RUNNING)

func handle_horizontal_flip(move_direction: float) -> void:
	if move_direction == 0:
		return
		
	player.sprite.flip_h = false if move_direction > 0 else true
	player.emit_signal("facing_direction_changed", !player.sprite.flip_h)
