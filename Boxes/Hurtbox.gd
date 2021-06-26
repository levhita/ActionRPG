extends Area2D

const HitEffect = preload("res://Effects/HitEffect.tscn")

export var INVINCIBILITY_DURATION = 0.5
export(bool) var SHOW_HIT = true
onready var timer = $Timer
onready var collision = $CollisionShape2D

signal invincibility_started
signal invincibility_finished

func create_hit_effect():
	var hitEffect = HitEffect.instance()
	var world = get_tree().current_scene
	world.add_child(hitEffect)
	hitEffect.global_position = global_position

func _on_Timer_timeout():
	collision.disabled = false
	emit_signal("invincibility_finished")

func _on_Hurtbox_area_entered(area):
	collision.set_deferred("disabled", true)
	emit_signal("invincibility_started")
	timer.start(INVINCIBILITY_DURATION)
	if SHOW_HIT:
		create_hit_effect()
