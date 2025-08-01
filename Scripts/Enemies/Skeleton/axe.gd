extends Area2D

@export var damage: int = 70
@export var animatedSprite: AnimatedSprite2D
@export var skeleton: Skeleton
@export var facing_shape: FacingCollisionShape2D

func _ready() -> void:
	monitoring = false

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		var push_direction_x: float = 1 if (body.global_position.x > global_position.x) else -1
		var push_direction_y: float = 1 if (body.global_position.y > global_position.x) else -1
		body.hit(damage, push_direction_x, push_direction_y)
		print(body.name + " took " + str(damage) + "dmg, current health = " + str(body.health))


func _on_animated_sprite_2d_frame_changed() -> void:
	if animatedSprite.animation == "attack" and animatedSprite.frame == 7:
		monitoring = true
	else:
		monitoring = false



func _on_enemy_facing_direction_changed(is_facing_right: bool) -> void:
	if is_facing_right:
		facing_shape.position = facing_shape.facing_right_postion
	else:
		facing_shape.position = facing_shape.facing_left_postion
