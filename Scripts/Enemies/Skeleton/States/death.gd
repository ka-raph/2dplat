extends SkeletonState

@export var death_timer: float = 0.0
@export var death_duration: float = 2.0
@export var sprite: AnimatedSprite2D

var fade_tween: Tween

func Enter():
	sprite.play("death")
	skeleton.velocity = Vector2.ZERO
	skeleton.set_deferred("collision_layer", 0)
	skeleton.set_physics_process(false)
	skeleton.axe.set_deferred("monitoring", false)

	## I may be dumb but I am basically trying to get the player to go through the 
	## dying skeleton instead of pushing it or bumping into it
	## and this is what I comme up with. Fix it if you can in a better way please :)
	_move_behind_player.call_deferred() # Works but now pushing it for some fucked up reason
	# Hate it but it worked!
	fade_tween = skeleton.create_tween()
	fade_tween.tween_property(skeleton, "modulate:a", 0.0, death_duration * 0.8).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

func Update(delta: float):
	death_timer += delta
	if death_timer >= death_duration:
		skeleton.queue_free()

func Physics_Update(delta: float):
	skeleton.velocity.x = 0


func _move_behind_player() -> void:
	var player := get_tree().get_first_node_in_group("Player")
	var parent := skeleton.get_parent()
	if player and player.get_parent() == parent and skeleton.get_index() > player.get_index():
		parent.move_child(skeleton, player.get_index())
