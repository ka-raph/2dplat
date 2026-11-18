class_name Skeleton
extends CharacterBody2D

signal enemy_facing_direction_changed(is_enemy_facing_right: bool)

@export var health: HealthComponent
@export var state_machine: StateMachine
@export var axe: Hitbox
@export var attack_range: float = 35.0

@onready var hurt_animation: AnimationPlayer = $HurtAnimation

var last_knockback: Vector2 = Vector2.ZERO
var is_facing_right: bool = true


func _ready() -> void:
	add_to_group("enemies")
	health.damaged.connect(_on_damaged)
	health.died.connect(func(): state_machine.change_state("Death"))


func _physics_process(_delta: float) -> void:
	move_and_slide()


func _on_damaged(_amount: float, knockback: Vector2) -> void:
	axe.set_deferred("monitoring", false)
	hurt_animation.play("hurt")
	last_knockback = knockback
	if not health.is_dead():
		state_machine.change_state("Hurt")


func face_towards(target_x: float, sprite: AnimatedSprite2D) -> void:
	var dx := target_x - global_position.x
	if dx == 0.0:
		return
	sprite.flip_h = dx < 0
	var facing_right := dx > 0
	if facing_right != is_facing_right:
		is_facing_right = facing_right
		enemy_facing_direction_changed.emit(is_facing_right)
