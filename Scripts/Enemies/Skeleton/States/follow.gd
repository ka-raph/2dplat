extends SkeletonState

@export var move_speed: float = 20.0
@export var attack_range: float = 30.0
@export var sprite: AnimatedSprite2D

var player: CharacterBody2D
var current_facing_right: bool = true

func Enter():
	player = get_tree().get_first_node_in_group("Player")
	sprite.play("walk")

func Update(delta: float):
	if not player or not is_instance_valid(player):
		Transitioned.emit(self, "Idle")
		return
	
	var direction = player.global_position - skeleton.global_position
	if sprite and direction.x != 0:
		var new_facing_right = direction.x > 0
		sprite.flip_h = direction.x < 0
		
		# Emit signal if facing direction changed
		if new_facing_right != current_facing_right:
			current_facing_right = new_facing_right
			skeleton.update_facing_direction(current_facing_right)
			
	if direction.length() <= attack_range:
		Transitioned.emit(self, "Attack")
	elif direction.length() > 200:
		Transitioned.emit(self, "Idle")

func Physics_Update(delta: float):
	if skeleton.health <= 0:
		Transition(self, "Death")
	var direction = player.global_position - skeleton.global_position
	
	if direction.length() > attack_range:
		skeleton.velocity.x = direction.normalized().x * move_speed
	else:
		skeleton.velocity.x = 0
		if sprite.animation != "idle":
			sprite.play("idle")
