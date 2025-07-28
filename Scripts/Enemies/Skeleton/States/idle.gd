class_name SkeletonIdle
extends State

@export var move_speed: float = 10.0
@export var skeleton: CharacterBody2D

var player: CharacterBody2D
var sprite: AnimatedSprite2D
var move_direction: Vector2
var wander_time: float = 5.0

func randomize_wander():
	Transitioned.emit(self, "Follow")
	move_direction = Vector2(randf_range(-1, 1), 0).normalized()
	wander_time = randf_range(1, 3)

func Enter():
	if skeleton:
		sprite = skeleton.get_node("AnimatedSprite2D")
	
	player = get_tree().get_first_node_in_group("Player")
	randomize_wander()
	
	if sprite:
		sprite.play("idle")

func Update(delta: float):
	wander_time -= delta
	if wander_time <= 0:
		randomize_wander()
		
	if player and is_instance_valid(player):
		var direction = player.global_position - skeleton.global_position
		if direction.length() < 100:
			Transitioned.emit(self, "Follow")

func Physics_Update(delta: float):
	if not skeleton or not is_instance_valid(skeleton):
		return
		
	skeleton.velocity.x = move_direction.x * move_speed
