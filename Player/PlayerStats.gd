extends Node

export(int) var max_health = 3 setget set_max_health
onready var health = max_health setget set_health

signal no_health
signal health_change(health)
signal max_health_change(max_health)

func set_max_health(value):
	max_health = max(value, 1)
	if health != null:
		self.health = min(health, max_health)
	emit_signal("max_health_change", max_health)
	
func set_health(value):
	health = clamp(value, 0, max_health)
	emit_signal("health_change", health)
	if health <= 0:
		emit_signal("no_health")
