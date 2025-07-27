class_name Player extends CharacterBody2D

@export var movement_component: MovementComponent
@export var input_component: InputComponent
@export var sprite: AnimatedSprite2D
@export var speed := 150.0
@export var gravity := 1000.0
@export var jump_impulse := 380.0

@onready var player_hurt_animation: AnimationPlayer = $PlayerHurtAnimation

var health: float = 100.0
var is_player_alive: bool = true
var is_enemy_in_attack_range: bool = false
var is_hurt: bool = false
var push_direction: float = 1
var is_attacking: bool = false

signal facing_direction_changed(is_facing_right: bool)

func _physics_process(delta: float) -> void:	
	if health <= 0:
		is_player_alive = false # Add handle respawn
		health = 0
		print("player is dead")
		get_tree().reload_current_scene()

func _on_player_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		is_enemy_in_attack_range = true
		push_direction = 1 if (body.global_position.x < global_position.x) else -1

func _on_player_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		is_enemy_in_attack_range = false

func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "attack1":
		is_attacking = false
	elif $AnimatedSprite2D.animation == "hurt":
		is_hurt = false

func update_facing_direction(is_facing_right: bool) -> void:
	self.emit_signal("facing_direction_changed", is_facing_right)
