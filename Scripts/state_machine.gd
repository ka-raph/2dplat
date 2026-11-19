class_name StateMachine
extends Node

@export var initial_state: State

var current_state: State
var states: Dictionary = {}

func _ready() -> void:
	for state_node: State in find_children("*", "State"):
		states[state_node.name] = state_node
		state_node.Transitioned.connect(on_child_transition)

	if initial_state:
		initial_state.Enter()
		current_state = initial_state

func _unhandled_input(event: InputEvent) -> void:
	if current_state and current_state.has_method("Handle_Input"):
		current_state.Handle_Input(event)

func _process(delta: float) -> void:
	if current_state:
		current_state.Update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.Physics_Update(delta)


func change_state(new_state_name: String) -> void:
	if current_state:
		on_child_transition(current_state, new_state_name)

func on_child_transition(state: State, new_state_name: String) -> void:
	if state != current_state:
		return

	var new_state: State = states.get(new_state_name)
	if !new_state:
		# DEVHOW: Juust in case I broke something
		printerr(owner.name + ": Trying to transition to state " + new_state_name + " but it doesn't exist.")
		return

	if current_state:
		current_state.Exit()

	new_state.Enter()
	current_state = new_state
