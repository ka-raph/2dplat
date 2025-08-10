class_name SkeletonState
extends "res://Scripts/state.gd"

const IDLE = "idle"
const FOLLOWING = "follow"
const ATTACK = "attack"
const HURT = "hurt"
const DEATH = "death"

@export var skeleton: Skeleton

func _ready() -> void:
	await owner.ready
	skeleton = owner as Skeleton
	assert(skeleton != null, "The SkeletonState type must be used only in the skeleton scene. It needs the owner to be a Skeleton node.")
