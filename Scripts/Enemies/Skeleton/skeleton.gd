class_name Skeleton
extends CharacterBody2D

@onready var hurt_animation: AnimationPlayer = $HurtAnimation
@onready var state_machine = $"State Machine"

var health: float = 120.0
var is_player_in_attack_zone: bool = false

func _physics_process(delta: float) -> void:
	move_and_slide()
	
	if health <= 0:
		if state_machine.current_state.name != "Death":
			state_machine.on_child_transition(state_machine.current_state, "Death")
		
func enemy() -> void:
	pass

func hit(damage: float, push_direction_x: float, push_direction_y: float) -> void:
	health -= damage
	hurt_animation.play("hurt")
	velocity.x = push_direction_x * 1000
	#velocity.y = push_direction_y * 1000 Uncomment for a laugh :D
