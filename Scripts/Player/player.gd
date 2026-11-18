class_name Player extends CharacterBody2D

@export var movement_component: MovementComponent
@export var input_component: InputComponent
@export var health: HealthComponent
@export var sword: Hitbox
@export var sprite: AnimatedSprite2D
@export var animation: AnimationPlayer
@export var hitbox_area: Hurtbox

@export var is_attacking: bool = false
@export var is_hurt: bool = false
@export var is_recovering: bool = false
@export var is_parrying: bool = false
@export var is_perfect_parry: bool = false
@export var is_dashing: bool = false
@export var dash_cooldown: Timer

var last_knockback: Vector2 = Vector2.ZERO # Better kockback handling

signal facing_direction_changed(is_facing_right: bool)
# Emitted when a dash starts. In case we want that rune system to affect dash
signal dashed


func _ready() -> void:
	health.damaged.connect(_on_damaged)


func _physics_process(delta: float) -> void:
	_update_damage_rules()
	movement_component.handle_movement(delta)


func _update_damage_rules() -> void:
	if is_perfect_parry:
		health.damage_multiplier = 0.0
	elif is_parrying:
		health.damage_multiplier = 0.5
	else:
		health.damage_multiplier = 1.0
	health.invulnerable = is_hurt or is_recovering


func _on_damaged(amount: float, knockback: Vector2) -> void:
	print("Player took " + str(amount) + " damage, health: " + str(health.health))
	last_knockback = knockback
	is_hurt = true
	health.invulnerable = true


func update_facing_direction(is_facing_right: bool) -> void:
	facing_direction_changed.emit(is_facing_right)


func _on_recovering_timeout() -> void:
	is_recovering = false
	_update_damage_rules()
	# Still standing in an enemy or an attack? Take that hit now.
	hitbox_area.recheck_overlaps()
