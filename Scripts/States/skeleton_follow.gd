class_name SkeletonFollow
extends State

@export var skeleton: CharacterBody2D
@export var move_speed: float = 40.0
var player: CharacterBody2D

func Enter():
	player = get_tree().get_first_node_in_group("Player")

func Physics_Update(delta: float):
	var direction = player.global_position - skeleton.global_position
	
	if direction.length() > 25:
		skeleton.velocity = direction.normalized() * move_speed
	else:
		skeleton.velocity = Vector2()
	
	if direction.length() > 200:
		Transitioned.emit(self, "idle")
