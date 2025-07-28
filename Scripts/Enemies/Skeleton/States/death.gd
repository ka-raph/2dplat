class_name SkeletonDeath
extends State

@export var skeleton: CharacterBody2D
@export var death_timer: float = 0.0
@export var death_duration: float = 2.0

var sprite: AnimatedSprite2D

func Enter():
	if skeleton:
		sprite = skeleton.get_node("AnimatedSprite2D")
	if sprite:
		sprite.play("death")

func Update(delta: float):
	death_timer += delta
	if death_timer >= death_duration:
		skeleton.queue_free()

func Physics_Update(delta: float):
	if not skeleton:
		return

	skeleton.velocity.x = 0
