class_name LevelExit extends Area2D

@export_file("*.tscn") var next_level: String
@export var spawn_name: String = "Start"

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		get_tree().current_scene.change_level(next_level, spawn_name)
