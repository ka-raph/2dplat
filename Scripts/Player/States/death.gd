class_name PlayerDeath
extends PlayerState

var sprite: AnimatedSprite2D
var death_timer: float = 0.0
var death_duration: float = 1.5

signal death_animation_complete

func Enter():
	if player:
		sprite = player.get_node("AnimatedSprite2D")
		if sprite:
			sprite.play("death")
		
		player.velocity = Vector2.ZERO
	
	death_timer = 0.0

func Physics_Update(delta: float) -> void:
	if player:
		player.velocity = Vector2.ZERO
	
	death_timer += delta
	if death_timer >= death_duration:
		# Some fade out needed here I guess or maybe better to handle in a game manager file?
		get_tree().reload_current_scene()

func Exit():
	death_timer = 0.0
