class_name Ghost
extends CharacterBody2D

@onready var hurt_animation: AnimationPlayer = $HurtAnimation

@export var sprite: AnimatedSprite2D
@export var health: HealthComponent
@export var stun_time: float = 0.2
@export var knockback_friction: float = 1200.0

var stun_timer: float = 0.0


func _ready() -> void:
	add_to_group("enemies")
	health.damaged.connect(_on_damaged)
	health.died.connect(queue_free)


func _physics_process(delta: float) -> void:
	if is_stunned():
		stun_timer -= delta
		velocity = velocity.move_toward(Vector2.ZERO, knockback_friction * delta)
	move_and_slide()


func is_stunned() -> bool:
	return stun_timer > 0.0


func _on_damaged(_amount: float, knockback: Vector2) -> void:
	hurt_animation.play("hurt")
	velocity = knockback
	stun_timer = stun_time
