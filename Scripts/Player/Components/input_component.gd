class_name InputComponent
extends Node

var input_horizontal: float = 0.0

func get_input_direction_x() -> float:
	return Input.get_axis("move_left", "move_right")

func get_jump_input() -> bool:
	return Input.is_action_just_pressed("jump")

func get_attack1_input() -> bool:
	return Input.is_action_just_pressed("attack1")

func get_parry_input() -> bool:
	return Input.is_action_just_pressed("parry")

func get_jump_input_released() -> bool:
	return Input.is_action_just_released("jump")
