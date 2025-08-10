extends SkeletonState

@export var death_timer: float = 0.0
@export var death_duration: float = 2.0
@export var sprite: AnimatedSprite2D

var fade_tween: Tween

func Enter():
	sprite.play("death")
	# Start fading out the skeleton
	fade_tween = skeleton.create_tween()
	fade_tween.tween_property(skeleton, "modulate:a", 0.0, death_duration * 0.8).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

func Update(delta: float):
	death_timer += delta
	if death_timer >= death_duration:
		skeleton.queue_free()

func Physics_Update(delta: float):
	skeleton.velocity.x = 0
