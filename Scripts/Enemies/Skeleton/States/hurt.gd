extends SkeletonState

@export var stun_time: float = 0.25
@export var friction: float = 1200.0
@export var sprite: AnimatedSprite2D

var _timer: float = 0.0

func Enter():
	_timer = stun_time
	sprite.play("hit")
	skeleton.velocity.x = skeleton.last_knockback.x

func Physics_Update(delta: float):
	skeleton.velocity.x = move_toward(skeleton.velocity.x, 0.0, friction * delta)
	_timer -= delta
	if _timer <= 0.0:
		Transition(self, FOLLOWING)
