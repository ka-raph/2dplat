class_name Skeleton
extends CharacterBody2D

@onready var hurt_animation: AnimationPlayer = $HurtAnimation

var health: float = 120.0
var is_player_in_attack_zone: bool = false

func _physics_process(delta: float) -> void:
	deal_with_damage()
	move_and_slide()
	if health <= 0:
		print("Skeleton is dead")
		self.queue_free()

func enemy() -> void:
	pass

func hit(damage: float, push_direction_x: float, push_direction_y: float) -> void:
	health -= damage
	hurt_animation.play("hurt")
	velocity.x = push_direction_x * 1000
	velocity.y = push_direction_y * 1000

func _on_skeleton_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		is_player_in_attack_zone = true


func _on_skeleton_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		is_player_in_attack_zone = false

func deal_with_damage() -> void:
	if is_player_in_attack_zone and Global.player_current_attack:
		# TODO emit state to take dmg + animation
		health -= 20
		print("skeleton health = ", health)
		if health <= 0:
			self.queue_free()
