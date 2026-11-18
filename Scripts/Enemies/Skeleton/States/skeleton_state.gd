class_name SkeletonState
extends State

const IDLE = "Idle"
const FOLLOWING = "Follow"
const ATTACK = "Attack"
const HURT = "Hurt"
const DEATH = "Death"

@export var skeleton: Skeleton

func _ready() -> void:
	await owner.ready
	skeleton = owner as Skeleton
	assert(skeleton != null, "Skeleton is null.")
