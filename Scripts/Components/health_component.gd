class_name HealthComponent
extends Node

signal damaged(amount: float, knockback: Vector2)
signal died
signal invulnerability_ended

@export var max_health: float = 100.0
@export var invulnerability_time: float = 0.2

var health: float
var damage_multiplier: float = 1.0
var invulnerable: bool = false
var _iframes_active: bool = false


func _ready() -> void:
	health = max_health


func is_dead() -> bool:
	return health <= 0.0


# Returns true if the hit actually landed.
func take_damage(amount: float, knockback: Vector2 = Vector2.ZERO) -> bool:
	var final_amount := amount * damage_multiplier
	if is_dead() or invulnerable or _iframes_active or final_amount <= 0.0:
		return false

	health = maxf(health - final_amount, 0.0)
	damaged.emit(final_amount, knockback)
	if is_dead():
		died.emit()
	elif invulnerability_time > 0.0:
		_start_iframes()
	return true


# Kept separate so take_damage() so its nota duplicate call.
func _start_iframes() -> void:
	_iframes_active = true
	await get_tree().create_timer(invulnerability_time).timeout
	_iframes_active = false
	invulnerability_ended.emit()
