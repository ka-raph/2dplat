class_name Player extends CharacterBody2D

@export var movement_component: MovementComponent
@export var input_component: InputComponent
@export var sprite: AnimatedSprite2D
@export var speed := 150.0
@export var gravity := 1000.0
@export var jump_impulse := 380.0
@export var hitbox_area: Area2D

@onready var player_hurt_animation: AnimationPlayer = $PlayerHurtAnimation

var health: float = 100.0
var is_player_alive: bool = true
var is_enemy_in_attack_range: bool = false
var is_hurt: bool = false
var push_direction: Vector2
var is_attacking: bool = false
var is_parrying: bool = false

signal facing_direction_changed(is_facing_right: bool)

func _physics_process(delta: float) -> void:
	if health <= 0:
		is_player_alive = false # Add handle respawn
		health = 0
		print("player is dead")
		get_tree().reload_current_scene()

func hit(damage: float) -> void:
	health -= damage

func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "attack1":
		is_attacking = false
	elif $AnimatedSprite2D.animation == "hurt":
		is_hurt = false
	elif $AnimatedSprite2D.animation == "parry":
		is_parrying = false

func update_facing_direction(is_facing_right: bool) -> void:
	self.emit_signal("facing_direction_changed", is_facing_right)

func _on_player_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemy"):
		is_enemy_in_attack_range = true
		push_direction.x = 1 if (area.owner.global_position.x < global_position.x) else -1
		push_direction.y = 1 if (area.owner.global_position.y < global_position.y) else -1

func _on_recover_cooldown_timeout() -> void:
	is_hurt = false
	print("Player has recovered")
	
	# Check if there is no other hurtful entity (only enemies so far) in the player's hitbox
	if hitbox_area.get_overlapping_areas().filter(check_has_overlapping_areas).size() == 0:
		print("No enemy touching player anymore")
		is_enemy_in_attack_range = false

# Perhaps we'll want a utils component/class for this kind of stuff
func check_has_overlapping_areas(overlappingArea: Area2D) -> bool:
	print("Is enemy hitbox overlapping" + str(overlappingArea.is_in_group("Enemy")))
	return overlappingArea.is_in_group("Enemy")
