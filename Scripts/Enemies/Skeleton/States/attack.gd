class_name SkeletonAttack
extends State

@export var attack_damage: float = 25.0
@export var attack_range: float = 30.0
@export var attack_cooldown: float = 1.5
@export var skeleton: CharacterBody2D

var player: CharacterBody2D
var sprite: AnimatedSprite2D
var can_attack: bool = true
var attack_timer: float = 0.0
var has_dealt_damage: bool = false
var animation_finished: bool = false
var attack_duration: float = 0.0

func Enter():
	
	if skeleton:
		sprite = skeleton.get_node("AnimatedSprite2D")
		if not sprite.frame_changed.is_connected(_on_sprite_frame_changed):
			sprite.frame_changed.connect(_on_sprite_frame_changed)
	
	player = get_tree().get_first_node_in_group("Player")
	can_attack = true
	attack_timer = 0.0
	has_dealt_damage = false
	animation_finished = true

func Update(delta: float):
	if not skeleton or not is_instance_valid(skeleton):
		return
	
	if not player or not is_instance_valid(player):
		Transitioned.emit(self, "Idle")
		return
	
	if not animation_finished:
		attack_duration += delta
		if attack_duration >= 1.5:
			animation_finished = true
			attack_duration = 0.0
	
	if not can_attack:
		attack_timer += delta
		if attack_timer >= attack_cooldown:
			can_attack = true
			attack_timer = 0.0
	
	var direction = player.global_position - skeleton.global_position
	if sprite and direction.x != 0:
		sprite.flip_h = direction.x < 0
	if animation_finished:
		if direction.length() > attack_range:
			Transitioned.emit(self, "Follow")
		elif direction.length() > 200:
			Transitioned.emit(self, "Idle")
		elif direction.length() <= attack_range and can_attack:
			pass

func Physics_Update(delta: float):
	if not skeleton or not is_instance_valid(skeleton):
		return
	if not player or not is_instance_valid(player):
		return
		
	skeleton.velocity.x = 0
	var direction = player.global_position - skeleton.global_position
	
	if direction.length() <= attack_range and can_attack and animation_finished:
		perform_attack()

func perform_attack():
	if not can_attack or not player:
		return
	
	var direction = player.global_position - skeleton.global_position
	if direction.length() > attack_range:
		return
		
	can_attack = false
	has_dealt_damage = false
	animation_finished = false
	attack_duration = 0.0
	if sprite:
		sprite.play("attack")

func _on_sprite_frame_changed():
	if sprite and sprite.animation == "attack" and sprite.frame == 7 and not has_dealt_damage:
		var direction = player.global_position - skeleton.global_position
		if direction.length() <= attack_range and player.has_method("hit"):
			var push_direction_x: float = 1 if (player.global_position.x > skeleton.global_position.x) else -1
			var push_direction_y: float = 1 if (player.global_position.y > skeleton.global_position.y) else -1
			player.hit(attack_damage, push_direction_x, push_direction_y)
			has_dealt_damage = true
