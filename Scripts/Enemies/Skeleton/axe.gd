extends Hitbox

@export var animatedSprite: AnimatedSprite2D
@export var skeleton: Skeleton
@export var facing_shape: FacingCollisionShape2D

func _ready() -> void:
	super()
	monitoring = false

func _on_animated_sprite_2d_frame_changed() -> void:
	var active := animatedSprite.animation == "attack" and animatedSprite.frame >= 7
	if active and not monitoring:
		begin_swing()
	monitoring = active

func _on_enemy_facing_direction_changed(is_enemy_facing_right: bool) -> void:
	if is_enemy_facing_right:
		facing_shape.position = facing_shape.facing_right_postion
	else:
		facing_shape.position = facing_shape.facing_left_postion


func _on_animated_sprite_2d_animation_finished() -> void:
	if animatedSprite.animation == "attack":
		monitoring = false
