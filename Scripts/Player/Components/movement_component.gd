class_name MovementComponent
extends Node

@export_subgroup("Settings")
@export var speed: float = 100
@export var player: Player

func handle_horizontal_movement(delta: float, is_skipping_flip: bool = false) -> float:
	var input_component: InputComponent = player.input_component
	var input_direction_x: float = input_component.get_input_direction_x()
	player.velocity.x = player.speed * input_direction_x
	player.velocity.y += player.gravity * delta
	if not is_skipping_flip:
		handle_horizontal_flip(input_direction_x)
	player.move_and_slide()
	
	return input_direction_x

func handle_horizontal_flip(move_direction: float) -> void:
	if move_direction == 0:
		return
		
	player.sprite.flip_h = false if move_direction > 0 else true
	player.update_facing_direction(!player.sprite.flip_h)
