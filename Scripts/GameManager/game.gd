extends Node2D

@export var start_level: PackedScene

@onready var level_holder: Node2D = $World/Level
@onready var player: Player = $World/Player
@onready var fade_rect: ColorRect = $World/FadeLayer/FadeRect

var current_level: Node
var is_transitioning := false

func _ready() -> void:
	_swap_level(start_level, "Start")

func change_level(level_path: String, spawn_name: String) -> void:
	if is_transitioning:
		return
	is_transitioning = true
	player.set_physics_process(false)             # freeze the player during the fade
	ResourceLoader.load_threaded_request(level_path)  # start loading in the background
	await _fade(1.0)                              # fade to black
	while ResourceLoader.load_threaded_get_status(level_path) == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		await get_tree().process_frame
	_swap_level(ResourceLoader.load_threaded_get(level_path), spawn_name)
	await _fade(0.0)                              # fade back in
	fade_rect.visible = false
	player.set_physics_process(true)
	is_transitioning = false

func _swap_level(scene: PackedScene, spawn_name: String) -> void:
	if current_level:
		current_level.queue_free()                # truly unloads it: physics, audio, everything
	current_level = scene.instantiate()
	current_level.visible = true
	level_holder.add_child(current_level)
	var spawn := current_level.find_child(spawn_name) as Marker2D
	if spawn:
		player.global_position = spawn.global_position
		player.velocity = Vector2.ZERO

func _fade(alpha: float) -> Signal:
	fade_rect.visible = true
	var tween := create_tween()
	tween.tween_property(fade_rect, "color:a", alpha, 0.3)
	return tween.finished
