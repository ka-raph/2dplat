extends SkeletonState

@export var attack_damage: float = 25.0
@export var attack_range: float = 40.0
@export var attack_cooldown: float = 1.5
@export var sprite: AnimatedSprite2D

var player: CharacterBody2D
var can_attack: bool = true
var attack_timer: float = 0.0
var current_facing_right: bool = true

func Enter():
	player = get_tree().get_first_node_in_group("Player")
	can_attack = true
	attack_timer = 0.0
	sprite.play("attack")

func Update(delta: float):
	if not player or not is_instance_valid(player):
		Transitioned.emit(self, "Idle")
		return
	
	if not can_attack:
		attack_timer += delta
		if attack_timer >= attack_cooldown:
			can_attack = true
			attack_timer = 0.0
	
	var direction = player.global_position - skeleton.global_position
	if sprite and direction.x != 0:
		var new_facing_right = direction.x > 0
		sprite.flip_h = direction.x < 0
		
		# Emit signal if facing direction changed
		if new_facing_right != current_facing_right:
			current_facing_right = new_facing_right
			skeleton.update_facing_direction(current_facing_right)
	
	if direction.length() > attack_range:
		Transitioned.emit(self, "Follow")
	elif direction.length() > 200:
		Transitioned.emit(self, "Idle")

func Physics_Update(delta: float):
	if skeleton.health <= 0:
		Transition(self, "Death")
	skeleton.velocity.x = 0
	var direction = player.global_position - skeleton.global_position
	if direction.length() <= attack_range and can_attack:
		perform_attack()

func perform_attack():
	if not can_attack or not player:
		return
