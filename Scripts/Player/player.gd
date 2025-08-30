class_name Player extends CharacterBody2D

@export var movement_component: MovementComponent
@export var input_component: InputComponent
@export var sprite: AnimatedSprite2D
@export var animation: AnimationPlayer
@export var hitbox_area: Area2D

# Variables handled (at least partly) by animations
@export var is_attacking: bool = false
@export var is_hurt: bool = false
@export var is_recovering: bool = false
@export var is_parrying: bool = false
@export var is_perfect_parry: bool = false

var health: float = 100.0
var is_player_alive: bool = true
var push_direction: Vector2

signal facing_direction_changed(is_facing_right: bool)

func _physics_process(delta: float) -> void:
	movement_component.handle_movement(delta)

func player() -> void:
	pass

func hit(damage: float) -> void:	
	print("Player hurt, health, incoming damage: " + str(health) + ", " + str(damage))
	var updated_damage = damage
	if is_perfect_parry:
		updated_damage = 0
	elif is_parrying:
		updated_damage /= 2
	print ("Updated damage: " + str(updated_damage))
	
	if is_hurt or is_recovering or is_perfect_parry:
		return
	health -= updated_damage
	is_hurt = true
	if health <= 0:
		health = 0 # Avoid negative health
		is_player_alive = false

func update_facing_direction(is_facing_right: bool) -> void:
	self.emit_signal("facing_direction_changed", is_facing_right)

# Add this stuff in a component that runs on states?
func _on_player_hitbox_area_entered(area: Area2D) -> void:
	if not area.monitoring:
		return
	if area.is_in_group("Enemy"):
		hit(15)
	if area.is_in_group("EnemyAttack"):
		hit(area.damage) # Make a class for those? Yes
	
	push_direction.x = 1 if (area.owner.global_position.x < global_position.x) else -1
	push_direction.y = 1 if (area.owner.global_position.y < global_position.y) else -1

# Perhaps we'll want a utils component/class for this kind of stuff
func check_has_overlapping_areas(overlappingArea: Area2D) -> bool:
	return overlappingArea.monitoring and (overlappingArea.is_in_group("Enemy") or overlappingArea.is_in_group("EnemyAttack"))

func get_highest_damage_overlapping_hurtful_area() -> float:
	var hurtfulAreas: Array[Area2D] = hitbox_area.get_overlapping_areas().filter(check_has_overlapping_areas)
	var highestDmg: float = 15 # Need to add a constant for that somewhere, that's the default value when monsters touch you
	for hurtfulArea in hurtfulAreas:
		if "damage" in hurtfulArea and hurtfulArea.damage > highestDmg:
			highestDmg = hurtfulArea.damage
	return highestDmg

func _on_recovering_timeout() -> void:
	is_recovering = false
	# Check if there is no other hurtful entity (only enemies so far) in the player's hitbox
	if hitbox_area.get_overlapping_areas().filter(check_has_overlapping_areas).size() == 0:
		is_hurt = false
	else:
		var damageTaken: float = get_highest_damage_overlapping_hurtful_area() # Do we want that or do we use the area "area_shape_entered" signal
		# and push the area RID in an array and then just keep the array updated if hurtful areas leave it (pop)/enter it(push)
		# and the first one in the array will be the next damage?????
		hit(damageTaken)
