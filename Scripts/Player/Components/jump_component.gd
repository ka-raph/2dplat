class_name JumpComponent
extends Node

@export_subgroup("Settings")
@export var jump_impulse := 380.0

@export_subgroup("Nodes")
@export var player: Player
@export var input_component: InputComponent
@export var jump_buffer_timer: Timer
@export var coyote_timer: Timer

# Jump variables
var want_to_jump: bool = false
var is_jumping: bool = false
var was_last_frame_on_floor: bool = false

func handle_jump() -> void:
	want_to_jump = input_component.get_jump_input()
	if has_just_landed():
		is_jumping = false
	
	if is_allowed_to_jump():
		jump()
	handle_coyote_time()
	handle_jump_buffer()
	handle_variable_jump_height(input_component.get_jump_input_released())
	was_last_frame_on_floor = player.is_on_floor()

func jump() -> void:
	player.velocity.y = -jump_impulse
	jump_buffer_timer.stop()
	is_jumping = true
	want_to_jump = false
	coyote_timer.stop()

func handle_variable_jump_height(is_jump_released: bool) -> void:
	if is_jump_released and player.velocity.y < 0 and not player.is_on_floor():
		player.velocity.y = 0

func handle_jump_buffer() -> void:
	if want_to_jump and not player.is_on_floor():
		jump_buffer_timer.start()
	if player.is_on_floor() and not jump_buffer_timer.is_stopped():
		jump()

func has_just_landed() -> bool:
	return player.is_on_floor() and not was_last_frame_on_floor and is_jumping

func handle_coyote_time() -> void:
	if has_just_stepped_off_ledge():
		coyote_timer.start()
	
	if not coyote_timer.is_stopped() and not is_jumping:
		player.velocity.y = 0

func has_just_stepped_off_ledge() -> bool:
	return not player.is_on_floor() and was_last_frame_on_floor and not is_jumping

func is_allowed_to_jump() -> bool:
	return want_to_jump and (player.is_on_floor() or not coyote_timer.is_stopped())
