class_name PlayerState extends State

const IDLE = "Idle"
const RUNNING = "Running"
const JUMPING = "Jumping"
const FALLING = "Falling"
const ATTACK1 = "Attack1"
const ATTACK2 = "Attack2"
const ATTACK3 = "Attack3"
const HURT = "Hurt"
const PARRY = "Parry"
const DEATH = "Death"
const DASH = "Dash"

@export var player: Player

func _ready() -> void:
	await owner.ready
	player = owner as Player
	assert(player != null, "Player is null")

func Handle_Input(_event: InputEvent) -> void:
	pass

## Hurt, attack, parry, dash. Returns true if it changed state.
func try_action_transitions() -> bool:
	var input := player.input_component
	if player.is_hurt and not player.is_recovering:
		Transition(self, HURT)
	elif input.consume(&"attack1"):
		Transition(self, ATTACK1)
	elif input.consume(&"parry"):
		Transition(self, PARRY)
	elif player.dash_cooldown.is_stopped() and input.consume(&"dash"):
		Transition(self, DASH)
	else:
		return false
	return true


## Idle / Running / Jumping / Falling based on velocity. Never transitions into itself.
func try_movement_transitions() -> void:
	var next: String
	if not player.is_on_floor():
		next = JUMPING if player.velocity.y < 0 else FALLING
	elif is_zero_approx(player.velocity.x) or _is_pushing_into_wall():
		next = IDLE
	else:
		next = RUNNING
	if next != name:
		Transition(self, next)


func _is_pushing_into_wall() -> bool:
	if not player.is_on_wall():
		return false
	var input_x := player.input_component.get_input_direction_x()
	return input_x * player.get_wall_normal().x < 0.0
