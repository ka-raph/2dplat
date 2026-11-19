extends SkeletonState

@export var attack_cooldown: float = 1.5
@export var sprite: AnimatedSprite2D

var player: CharacterBody2D
var can_attack: bool = true
var attack_timer: float = 0.0

func Enter():
	player = get_tree().get_first_node_in_group("Player")
	can_attack = true
	attack_timer = 0.0
	sprite.play("attack")

func Update(delta: float):
	if not player or not is_instance_valid(player):
		Transition(self, IDLE)
		return

	if not can_attack:
		attack_timer += delta
		if attack_timer >= attack_cooldown:
			can_attack = true
			attack_timer = 0.0

	skeleton.face_towards(player.global_position.x, sprite)

	var distance := player.global_position.distance_to(skeleton.global_position)
	if distance > 200:
		Transition(self, IDLE)
	elif distance > skeleton.attack_range:
		Transition(self, FOLLOWING)

func Physics_Update(_delta: float):
	skeleton.velocity.x = 0
	if not player or not is_instance_valid(player):
		return
	var distance := player.global_position.distance_to(skeleton.global_position)
	if distance <= skeleton.attack_range and can_attack:
		perform_attack()

func perform_attack():
	if not can_attack or not player:
		return
