class_name SkeletonDeath
extends SkeletonState

@export var sprite: AnimatedSprite2D

var death_timer: float = 0.0
var death_duration: float = 2.0

signal death_animation_complete

func Enter():
	sprite.play("death")
	skeleton.velocity = Vector2.ZERO
	death_timer = 0.0

func Physics_Update(delta: float):
	skeleton.velocity = Vector2.ZERO
	death_timer += delta
	if death_timer >= death_duration:
		skeleton.queue_free()
	
func Exit():
	death_timer = 0.0
