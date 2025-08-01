class_name SkeletonFollow
extends State

@export var skeleton: CharacterBody2D
@export var move_speed: float = 20.0
@export var attack_range: float = 30.0

var player: CharacterBody2D
var sprite: AnimatedSprite2D

func Enter():
	if skeleton:
		sprite = skeleton.get_node("AnimatedSprite2D")
	
	player = get_tree().get_first_node_in_group("Player")
	
	if sprite:
		sprite.play("walk")

func Update(delta: float):
	
	if not skeleton or not is_instance_valid(skeleton):
		return
	if not player or not is_instance_valid(player):
		Transitioned.emit(self, "Idle")
		return
	
	var direction = player.global_position - skeleton.global_position
	if sprite and direction.x != 0:
		sprite.flip_h = direction.x < 0
	if direction.length() <= attack_range:
		Transitioned.emit(self, "Attack")
	elif direction.length() > 200:
		Transitioned.emit(self, "Idle")

func Physics_Update(delta: float):
	if not skeleton or not is_instance_valid(skeleton):
		return
	if not player or not is_instance_valid(player):
		return
	
	var direction = player.global_position - skeleton.global_position
	
	if direction.length() > attack_range:
		skeleton.velocity.x = direction.normalized().x * move_speed
	else:
		skeleton.velocity.x = 0
		
		if sprite and sprite.animation != "idle":
			sprite.play("idle")
