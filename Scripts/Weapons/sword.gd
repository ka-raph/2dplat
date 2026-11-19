extends Hitbox

@export var player: Player
@export var facing_shape: FacingCollisionShape2D

var direction_modifier: float = 1
## How far behind the player (in pixels) an enemy can be and still get hit.
@export var behind_tolerance: float = 4.0


func _ready() -> void:
	# Runs Hitbox._ready()
	super()
	monitoring = false
	landed_hit.connect(_on_landed_hit)


# Can't hit enemies we are facing away from.
func can_hit(hurtbox: Hurtbox) -> bool:
	if not super(hurtbox):
		return false
	var facing := -1.0 if player.sprite.flip_h else 1.0
	var dx := hurtbox.global_position.x - player.global_position.x
	return dx * facing >= -behind_tolerance


# Fixed the messy hitstop.
func _on_landed_hit(_target: Hurtbox) -> void:
	if is_first_hit_of_swing():
		CombatFeedback.hitstop(0.07)
		CombatFeedback.shake(3.0)


func _on_player_facing_direction_changed(is_facing_right: bool) -> void:
	if is_facing_right:
		facing_shape.position = facing_shape.facing_right_postion
	else:
		facing_shape.position = facing_shape.facing_left_postion
	direction_modifier = 1 if is_facing_right else -1


func transform_hitbox_attack_start() -> void:
	facing_shape.position.x = -5 * direction_modifier
	facing_shape.position.y = 2
	facing_shape.scale.x = 2.5
	facing_shape.scale.y = 1.2


func transform_hitbox_attack_core() -> void:
	facing_shape.position.x = 18 * direction_modifier
	facing_shape.position.y = 5
	facing_shape.scale.x = 1
	facing_shape.scale.y = 1
