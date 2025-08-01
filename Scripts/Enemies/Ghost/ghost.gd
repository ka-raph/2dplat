class_name Ghost
extends CharacterBody2D

@onready var hurt_animation: AnimationPlayer = $HurtAnimation

@export var sprite: AnimatedSprite2D

var health: float = 100.0
var is_player_in_attack_zone: bool = false

func _physics_process(delta: float) -> void:
	move_and_slide()
	if health <= 0:
		print("Ghost is dead")
		self.queue_free()

func enemy() -> void:
	pass

func hit(damage: float, push_direction_x: float, push_direction_y: float) -> void:
	health -= damage
	hurt_animation.play("hurt")
	velocity.x = push_direction_x * 1000
	velocity.y = push_direction_y * 1000
