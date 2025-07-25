class_name State
extends Node

signal Transitioned

# Only for the player
func Handle_Input(_event: InputEvent) -> void:
	pass

func Enter():
	pass

func Exit():
	pass

func Update(_delta: float):
	pass

func Physics_Update(_delta: float):
	pass
