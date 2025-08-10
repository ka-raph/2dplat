class_name Skeleton
extends CharacterBody2D

@onready var hurt_animation: AnimationPlayer = $HurtAnimation

var health: float = 120.0
var is_player_in_attack_zone: bool = false

signal enemy_facing_direction_changed(is_enemy_facing_right: bool)

func _physics_process(delta: float) -> void:
	move_and_slide()
	if health <= 0:
		health = 0
		
func enemy() -> void:
	pass

func hit(damage: float, push_direction_x: float, push_direction_y: float) -> void:
	health -= damage
	hurt_animation.play("hurt")
	
func update_facing_direction(is_enemy_facing_right: bool) -> void:
	self.emit_signal("enemy_facing_direction_changed", is_enemy_facing_right)
