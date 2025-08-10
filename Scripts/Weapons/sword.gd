extends Area2D

@export var damage: int = 70
@export var animatedSprite: AnimatedSprite2D
@export var player: Player
@export var facing_shape: FacingCollisionShape2D

func _ready() -> void:
	monitoring = false

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		body.hit(damage, 0, 0)
		print(body.name + " took " + str(damage) + "dmg, current health = " + str(body.health))

func _on_animated_sprite_2d_frame_changed() -> void:
	if animatedSprite.animation == "attack1" and animatedSprite.frame == 3:
		monitoring = true
	else:
		monitoring = false

func _on_player_facing_direction_changed(is_facing_right: bool) -> void:
	if is_facing_right:
		facing_shape.position = facing_shape.facing_right_postion
	else:
		facing_shape.position = facing_shape.facing_left_postion
