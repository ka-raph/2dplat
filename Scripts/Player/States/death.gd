extends PlayerState

var death_timer: float = 0.0
var fade_started: bool = false

func Enter() -> void:
	player.velocity.x = 0.0
	player.sprite.play("death")

func Update(delta: float) -> void:
	death_timer += delta
	
	# Start fade after death animation has played for a bit
	if death_timer >= 0.3 and not fade_started:
		fade_started = true
		start_fade_out()

func Physics_Update(delta: float) -> void:
	player.velocity.x = 0.0
	player.velocity.y += player.movement_component.gravity * delta
	player.move_and_slide()

func start_fade_out():
	# TODO use dedicated names
	var fade_layer = get_tree().get_first_node_in_group("FadeLayer")
	fade_layer = get_tree().current_scene.get_node("World/FadeLayer")
	fade_layer.fade_out_on_death(2)
