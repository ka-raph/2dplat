class_name InputComponent
extends Node

@export var buffer_time_ms: int = 150

const BUFFERED_ACTIONS: Array[StringName] = [&"attack1", &"parry", &"dash"]

var _pressed_at: Dictionary = {}


func _unhandled_input(event: InputEvent) -> void:
	for action in BUFFERED_ACTIONS:
		if event.is_action_pressed(action):
			_pressed_at[action] = Time.get_ticks_msec()


func consume(action: StringName) -> bool:
	var pressed_at: int = _pressed_at.get(action, -100000)
	if Time.get_ticks_msec() - pressed_at <= buffer_time_ms:
		_pressed_at.erase(action)
		return true
	return false


func get_input_direction_x() -> float:
	return Input.get_axis("move_left", "move_right")


func get_jump_input() -> bool:
	return Input.is_action_just_pressed("jump")


func get_jump_input_released() -> bool:
	return Input.is_action_just_released("jump")
