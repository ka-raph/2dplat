class_name Ghost
extends CharacterBody2D

var health: float = 100.0
var is_player_in_attack_zone: bool = false

func _physics_process(delta: float) -> void:
	deal_with_damage()
	move_and_slide()

func enemy() -> void:
	pass


func _on_ghost_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		is_player_in_attack_zone = true


func _on_ghost_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		is_player_in_attack_zone = false

func deal_with_damage() -> void:
	if is_player_in_attack_zone and Global.player_current_attack:
		# TODO emit state to take dmg + animation
		health -= 20
		print("Ghost health = ", health)
		if health <= 0:
			self.queue_free()
