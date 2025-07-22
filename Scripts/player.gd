extends CharacterBody2D

@export_subgroup("Nodes")
@export var gravity_component: GravityComponent
@export var input_component: InputComponent
@export var movement_component: MovementComponent
@export var animation_component: AnimationComponent
@export var jump_component: JumpComponent

@onready var player_hurt_animation: AnimationPlayer = $PlayerHurtAnimation


var is_enemy_in_attack_range: bool = false
var is_recovering: bool = false
var is_hurt: bool = false
var health: float = 100
var is_player_alive: bool = true

var attack_in_progress: bool = false

func _physics_process(delta: float) -> void:
	# Component listeners
	gravity_component.handle_gravity(self, delta)
	movement_component.handle_horizontal_movement(self, input_component.input_horizontal, is_recovering)
	animation_component.handle_move_animation(input_component.input_horizontal)
	animation_component.handle_jump_animation(jump_component.is_jumping, gravity_component.is_falling)
	animation_component.handle_hurt_animation(is_hurt)
	jump_component.handle_jump(self, input_component.get_jump_input())
	
	# Basic listeners
	enemy_attack()
	move_and_slide()
	
	# TODO make dmg + attack in components
	if health <= 0:
		is_player_alive = false # Add handle respawn
		health = 0
		print("player is dead")
		# to delete the player node: self.queue_free() but should delete all monsters and such instead perhaps?

func player() -> void:
	pass

func _on_player_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		is_enemy_in_attack_range = true
		# Avoid re-triggering a hit
		# $CollisionShape2D.set_deferred("disabled", true)


func _on_player_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		is_enemy_in_attack_range = false

func enemy_attack() -> void:
	if is_enemy_in_attack_range and not is_recovering:
		health -= 20
		is_recovering = true
		is_hurt = true
		$RecoveringCooldown.start()
		$HurtCooldown.start()
		player_hurt_animation.play("playerHurt")
		print(health)


func _on_damage_cooldown_timeout() -> void:
	is_recovering = false


func _on_hurt_cooldown_timeout() -> void:
	is_hurt = false
