class_name MovementComponent
extends Node

@export_subgroup("Settings")
@export var speed: float = 150.0
@export var ground_accel: float = 600.0
@export var ground_decel: float = 1200.0
@export var air_accel: float = 600.0
@export var air_decel: float = 1080.0
@export var gravity: float = 1000.0
@export var dash: float = 350.0

@export_subgroup("Nodes")
@export var player: Player
@export var input_component: InputComponent
@export var jump_component: JumpComponent

var speed_multiplier: float = 1.0
var control_enabled: bool = true
var can_turn: bool = true

var dash_velocity: float = 0.0


func handle_movement(delta: float) -> void:
	if player.is_dashing:
		player.move_and_slide()
		return
		
	var input_direction_x: float = input_component.get_input_direction_x() if control_enabled else 0.0
	var rate: float
	if player.is_on_floor():
		rate = ground_accel if input_direction_x != 0 else ground_decel
	else:
		rate = air_accel if input_direction_x != 0 else air_decel

	player.velocity.x = move_toward(player.velocity.x, input_direction_x * speed * speed_multiplier, rate * delta)
	player.velocity.y += gravity * delta

	# Attacks lock facing so you can't spin around mid-swing.
	if can_turn:
		handle_horizontal_flip(input_direction_x)
	# No jumping while hurt or dead.
	if control_enabled:
		jump_component.handle_jump()
	player.move_and_slide()


func handle_horizontal_flip(move_direction: float) -> void:
	if move_direction == 0:
		return

	player.sprite.flip_h = false if move_direction > 0 else true
	player.update_facing_direction(!player.sprite.flip_h)


func handle_dashing(move_direction: float) -> void:
	dash_velocity = dash * move_direction
	player.velocity.x = dash_velocity
	player.velocity.y = 0
