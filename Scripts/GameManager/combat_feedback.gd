# Autoloader for screen shake and hit stop.
extends Node

@export var shake_decay: float = 30.0

var _shake: float = 0.0
var _hitstop_id: int = 0


func hitstop(duration: float, slow_scale: float = 0.05) -> void:
	_hitstop_id += 1
	var my_id := _hitstop_id
	Engine.time_scale = slow_scale

	await get_tree().create_timer(duration, true, false, true).timeout
	if my_id == _hitstop_id:
		Engine.time_scale = 1.0

# Added a tiny impact screen shake for affect. Can be removed if you don't like it.
func shake(strength: float) -> void:
	_shake = maxf(_shake, strength)


func _process(delta: float) -> void:
	var cam := get_viewport().get_camera_2d()
	if cam == null:
		return
	var real_delta := delta / maxf(Engine.time_scale, 0.001)
	_shake = move_toward(_shake, 0.0, shake_decay * real_delta)
	cam.offset = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)) * _shake
