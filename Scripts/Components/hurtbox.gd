class_name Hurtbox
extends Area2D

@export var health: HealthComponent


func _ready() -> void:
	# When i-frames end, check if we're still inside something that hurts.
	health.invulnerability_ended.connect(recheck_overlaps)


func recheck_overlaps() -> void:
	for area in get_overlapping_areas():
		if area is Hitbox and area.monitoring:
			var health_before := health.health
			(area as Hitbox).apply_hit(self)
			if health.health < health_before:
				return
