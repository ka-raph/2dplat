class_name SkeletonState extends State

const IDLE = "Idle"
const FOLLOWING = "follow"
const ATTACK1 = "Attack1"
const HURT = "Hurt"
const DEATH = "Death"

@export var skeleton: Skeleton

func _ready() -> void:
	await owner.ready
	skeleton = owner as Skeleton
	assert(skeleton != null, "The SkeletonState type must be used only in the skeleton scene. It needs the owner to be a Skeleton node.")

func handle_input(_event: InputEvent) -> void:
	pass
