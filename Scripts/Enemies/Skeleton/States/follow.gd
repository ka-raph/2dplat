extends SkeletonState

@export var move_speed: float = 20.0
@export var sprite: AnimatedSprite2D

var player: CharacterBody2D

func Enter():
	player = get_tree().get_first_node_in_group("Player")
	sprite.play("walk")

func Update(_delta: float):
	if not player or not is_instance_valid(player):
		Transition(self, IDLE)
		return

	skeleton.face_towards(player.global_position.x, sprite)

	var distance := player.global_position.distance_to(skeleton.global_position)
	if distance <= skeleton.attack_range:
		Transition(self, ATTACK)
	elif distance > 200:
		Transition(self, IDLE)

func Physics_Update(_delta: float):
	if not player or not is_instance_valid(player):
		return
	var direction = player.global_position - skeleton.global_position

	if direction.length() > skeleton.attack_range:
		skeleton.velocity.x = direction.normalized().x * move_speed
	else:
		skeleton.velocity.x = 0
		if sprite.animation != "idle":
			sprite.play("idle")
