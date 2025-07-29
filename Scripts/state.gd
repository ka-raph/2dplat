class_name State
extends Node

signal Transitioned

func Enter():
	pass

func Exit():
	pass

func Update(_delta: float):
	pass

func Physics_Update(_delta: float):
	pass

func Transition(current_state: State, next_state: String):
	Transitioned.emit(current_state, next_state)
