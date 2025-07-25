extends PlayerState

func Enter() -> void:
	player.velocity.y = -player.jump_impulse
	player.sprite.play("jump")

func Physics_Update(delta: float) -> void:
	var input_direction_x := Input.get_axis("move_left", "move_right")
	player.velocity.x = player.speed * input_direction_x
	player.velocity.y += player.gravity * delta
	handle_horizontal_flip(input_direction_x)
	player.move_and_slide()

	if player.velocity.y >= 0:
		Transitioned.emit(self, FALLING)

func Handle_Input(event: InputEvent) -> void:
	pass

func handle_horizontal_flip(move_direction: float) -> void:
	if move_direction == 0:
		return
		
	player.sprite.flip_h = false if move_direction > 0 else true
