class_name Hitbox
extends Area2D

signal landed_hit(target: Hurtbox)

@export var damage: float = 10.0
@export var knockback_force: float = 250.0
@export var knockback_lift: float = 80.0
# Only Hurtboxes whose owner is in this group get hit.
@export var target_group: StringName = &"enemies"
# True for swings: each target is hit at most once per swing (begin_swing call).
# False for constant contact damage, like a ghost's body. this presents it own problems btw. we can talk about it
@export var once_per_swing: bool = true

var _hit_this_swing: Array[Hurtbox] = []


func _ready() -> void:
	area_entered.connect(_on_area_entered)


func begin_swing() -> void:
	_hit_this_swing.clear()


func is_first_hit_of_swing() -> bool:
	return _hit_this_swing.size() == 1


func can_hit(hurtbox: Hurtbox) -> bool:
	if hurtbox.owner == owner or not hurtbox.owner.is_in_group(target_group):
		return false
	return not (once_per_swing and hurtbox in _hit_this_swing)


func apply_hit(hurtbox: Hurtbox) -> void:
	if not can_hit(hurtbox):
		return

	# Push away from whoever is attacking (not from the hitbox shape)
	var origin: Vector2 = global_position
	if owner is Node2D:
		origin = (owner as Node2D).global_position
	var dir_x := signf(hurtbox.global_position.x - origin.x)
	if dir_x == 0.0:
		dir_x = 1.0
	var knockback := Vector2(dir_x * knockback_force, -knockback_lift)

	if hurtbox.health.take_damage(damage, knockback):
		if once_per_swing:
			_hit_this_swing.append(hurtbox)
		landed_hit.emit(hurtbox)


func _on_area_entered(area: Area2D) -> void:
	if area is Hurtbox:
		apply_hit(area)
