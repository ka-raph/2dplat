extends Area2D

@export var damage: int = 70
@export var animationPlayer: AnimationPlayer
@export var player: Player
@export var facing_shape: FacingCollisionShape2D

var direction_modifier: float = 1

func _ready() -> void:
	monitoring = false

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		body.hit(damage, 0, 0)
		print(body.name + " took " + str(damage) + "dmg, current health = " + str(body.health))

func _on_player_facing_direction_changed(is_facing_right: bool) -> void:
	if is_facing_right:
		facing_shape.position = facing_shape.facing_right_postion
	else:
		facing_shape.position = facing_shape.facing_left_postion
	direction_modifier = 1 if is_facing_right else -1

func transform_hitbox_attack_start() -> void:
	facing_shape.position.x = -5 * direction_modifier
	facing_shape.position.y = 2
	facing_shape.scale.x = 2.5
	facing_shape.scale.y = 1.2

func transform_hitbox_attack_core() -> void:
	facing_shape.position.x = 18 * direction_modifier
	facing_shape.position.y = 5
	facing_shape.scale.x = 1
	facing_shape.scale.y = 1
