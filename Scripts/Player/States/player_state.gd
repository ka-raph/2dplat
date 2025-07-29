class_name PlayerState extends State

const IDLE = "Idle"
const RUNNING = "Running"
const JUMPING = "Jumping"
const FALLING = "Falling"
const ATTACK1 = "Attack1"
const ATTACK2 = "Attack2"
const ATTACK3 = "Attack3"
const HURT = "Hurt"
const DEATH = "Death"

@export var player: Player

func _ready() -> void:
	await owner.ready
	player = owner as Player
	assert(player != null, "The PlayerState type must be used only in the player scene. It needs the owner to be a Player node.")

func handle_input(_event: InputEvent) -> void:
	pass
