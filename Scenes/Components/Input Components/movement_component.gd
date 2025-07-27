class_name MovementComponent
extends Node

@export_subgroup("Settings")
@export var speed: float = 100

func handle_horizontal_movement(body: CharacterBody2D, direction: float, is_recovering: bool) -> void:
	if not is_recovering:
		body.velocity.x = direction * speed
