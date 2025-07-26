class_name Player extends CharacterBody2D

@export var sprite: AnimatedSprite2D
@export var speed := 150.0
@export var gravity := 1000.0
@export var jump_impulse := 380.0


@onready var player_hurt_animation: AnimationPlayer = $PlayerHurtAnimation

var health: float = 100.0
var is_player_alive: bool = true
var is_enemy_in_attack_range: bool = false
var is_recovering: bool = false
var is_hurt: bool = false
var push_direction: float = 1
var is_attacking: bool = false

func _physics_process(delta: float) -> void:
	# TODORAF state that line
	enemy_touched()
	
	# TODO make dmg + attack in states
	if health <= 0:
		is_player_alive = false # Add handle respawn
		health = 0
		print("player is dead")
		get_tree().reload_current_scene()
		# to delete the player node: self.queue_free() but should delete all monsters and such instead perhaps?

func player() -> void:
	pass

func _on_player_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		is_enemy_in_attack_range = true
		push_direction = 1 if (body.global_position.x < global_position.x) else -1


func _on_player_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		is_enemy_in_attack_range = false

func enemy_touched() -> void:
	if is_enemy_in_attack_range and not is_recovering:
		health -= 20
		is_recovering = true
		is_hurt = true
		$RecoveringCooldown.start()
		$HurtCooldown.start()
		player_hurt_animation.play("playerHurt")
		velocity.x = push_direction * 75
		velocity.y = -75
		print(health)


func _on_damage_cooldown_timeout() -> void:
	is_recovering = false


func _on_hurt_cooldown_timeout() -> void:
	is_hurt = false


func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "attack1":
		is_attacking = false
