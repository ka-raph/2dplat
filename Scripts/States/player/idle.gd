extends PlayerState

func Enter() -> void:
	player.velocity.x = 0.0
	player.sprite.play("idle")

func Physics_Update(_delta: float) -> void:
	player.velocity.y += player.gravity * _delta
	player.move_and_slide()

	if not player.is_on_floor():
		Transitioned.emit(self, FALLING)
	elif Input.is_action_just_pressed("jump"):
		Transitioned.emit(self, JUMPING)
	elif Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		Transitioned.emit(self, RUNNING)

func Handle_Input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("jump"):
		Transitioned.emit(self, JUMPING)
	elif Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		Transitioned.emit(self, RUNNING)
