class_name Crate
extends StaticBody2D

@export var hits_to_break: int = 3
@export var health: HealthComponent
@export var sprite: Sprite2D

var _hits: int = 0


func _ready() -> void:
	# Added to enemy group.
	add_to_group("enemies")
	health.damaged.connect(_on_damaged)


func _on_damaged(_amount: float, _knockback: Vector2) -> void:
	_hits += 1
	health.health = health.max_health
	if _hits >= hits_to_break:
		_break()
	else:
		_hit_feedback()


func _hit_feedback() -> void:
	# Quick white flash and a little wobble.
	var tween := create_tween()
	sprite.modulate = Color(3, 3, 3)
	tween.tween_property(sprite, "modulate", Color.WHITE, 0.12)
	var shake := create_tween()
	shake.tween_property(sprite, "position:x", 2.0, 0.03)
	shake.tween_property(sprite, "position:x", -2.0, 0.05)
	shake.tween_property(sprite, "position:x", 0.0, 0.03)


func _break() -> void:
	$CollisionShape2D.set_deferred("disabled", true)
	$Hurtbox.set_deferred("monitorable", false)
	var tween := create_tween().set_parallel()
	tween.tween_property(sprite, "scale", Vector2(1.3, 0.2), 0.12)
	tween.tween_property(sprite, "modulate:a", 0.0, 0.12)
	tween.chain().tween_callback(queue_free)
