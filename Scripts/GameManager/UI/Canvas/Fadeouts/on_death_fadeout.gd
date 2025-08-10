extends CanvasLayer

# This file probably needs to change later, but for now this will do
# Using set.meta is a little unsafe

@export var fade_out_duration: float = 1.2
@export var fade_in_duration: float = 2.0
@export var blackout_duration: float = 2.0

@onready var fade_rect := $FadeRect

func _ready():
	# DOnt fade in on game start, only after death
	if get_tree().has_meta("should_fade_in"):
		# Wanted to handle this in a GameManager file but couldn't get around it needing to be static
		get_tree().remove_meta("should_fade_in")
		fade_in()

func fade_out_on_death(blackout_duration: float):
	fade_rect.color.a = 0.0
	fade_rect.visible = true
	var tween = create_tween()
	# Use "color:a" NOT color.a! Confused me for ages
	tween.tween_property(fade_rect, "color:a", 1.0, fade_out_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_interval(blackout_duration)
	tween.tween_callback(Callable(self, "_on_blackout_finished"))

func fade_in():
	fade_rect.color.a = 1.0
	fade_rect.visible = true
	var tween = create_tween()
	tween.tween_property(fade_rect, "color:a", 0.0, fade_in_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_callback(func(): fade_rect.visible = false)

func _on_fade_out_finished():
	print("restarting game...")
	get_tree().reload_current_scene()

func _on_blackout_finished():
	print("respawning player...")
	# Set meta is a bit shit, but haven't found any decent alternatives yet. Needs a discussion
	get_tree().set_meta("should_fade_in", true)
	get_tree().reload_current_scene()
