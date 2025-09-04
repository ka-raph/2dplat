class_name MovementComponent
extends Node

@export_subgroup("Settings")
@export var speed: float = 150.0
@export var ground_accel_speed: float = 10.0
@export var ground_decel_speed: float = 20.0
@export var air_accel_speed: float = 10.0
@export var air_decel_speed: float = 18.0
@export var jump_velocity: float = -350.0
@export var gravity := 1000.0
@export var jump_impulse := 380.0
@export var dash: float = 350.0
@export var dash_velocity: float = 0.0

@export_subgroup("Nodes")
@export var player: Player
@export var input_component: InputComponent
@export var jump_component: JumpComponent

func handle_movement(delta: float, is_skipping_flip: bool = false) -> float:
	# Need to handle wall collision detection
	# When the player walks into a wall, the animation bugs out (looks pretty stupid)
	var input_direction_x: float = input_component.get_input_direction_x()
	var velocity_change_speed: float = 0.0
	if player.is_on_floor():
		velocity_change_speed = ground_accel_speed if input_direction_x != 0 else ground_decel_speed
	else:
		velocity_change_speed = air_accel_speed if input_direction_x != 0 else air_decel_speed
	
	player.velocity.x = move_toward(player.velocity.x, input_direction_x * speed, velocity_change_speed)
	player.velocity.y += gravity * delta
	
	if not is_skipping_flip:
		handle_horizontal_flip(input_direction_x)
	
	jump_component.handle_jump()
	player.move_and_slide()
	
	return input_direction_x

func handle_horizontal_flip(move_direction: float) -> void:
	if move_direction == 0:
		return
		
	player.sprite.flip_h = false if move_direction > 0 else true
	player.update_facing_direction(!player.sprite.flip_h)
	
func handle_dashing(move_direction: float) -> void:
	# Todo: Figure out a way to transistion back to running after dashing in a graceful way. Right now we just slide endlessly if we dah and hold the movement keys
	if not player.has_just_dashed:
		dash_velocity = dash * move_direction
		player.velocity.x = dash_velocity
		player.velocity.y = 0
