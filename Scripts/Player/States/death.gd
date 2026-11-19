extends PlayerState

var death_timer: float = 0.0
var fade_started: bool = false

func Enter() -> void:
	player.velocity.x = 0.0
	player.sprite.play("death")
	player.movement_component.control_enabled = false

func Update(delta: float) -> void:
	death_timer += delta

	# Start fade after death animation has played for a bit
	if death_timer >= 0.3 and not fade_started:
		fade_started = true
		start_fade_out()

func Physics_Update(_delta: float) -> void:
	player.velocity.x = 0.0

func start_fade_out() -> void:
	# One lookup now, I made an override by by accident.
	var fade_layer = get_tree().get_first_node_in_group("FadeLayer")
	if fade_layer == null:
		fade_layer = get_tree().current_scene.get_node_or_null("World/FadeLayer")
	if fade_layer:
		fade_layer.fade_out_on_death(2)
