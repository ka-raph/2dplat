class_name AnimationComponent
extends Node

@export_subgroup("Nodes")
@export var sprite: AnimatedSprite2D

func handle_horizontal_flip(move_direction: float) -> void:
	if move_direction == 0:
		return
		
	sprite.flip_h = false if move_direction > 0 else true
	
func handle_move_animation(is_attacking: bool, is_hurt, move_direction: float) -> void:
	handle_horizontal_flip(move_direction)
	
	if move_direction != 0:
		sprite.play("run")
	elif not is_attacking and not is_hurt:
		sprite.play("idle")

func handle_jump_animation(is_jumping: bool, is_falling: bool) -> void:
	if is_jumping:
		sprite.play("jump")
	elif is_falling:
		sprite.play("fall")
		
func handle_hurt_animation(is_hurt: bool) -> void:
	if is_hurt:
		sprite.play("hurt")
		
# Enum needed (We think)
func handle_attack_animation(is_attacking: bool) -> void:
	if is_attacking:
		sprite.play("attack1")
