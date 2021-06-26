extends Node2D

export(int) var wander_range = 32
export(float) var wait_time = 2
export(float) var wait_time_range = 1

onready var starting_position = global_position
onready var target_position = global_position
onready var timer = $Timer

signal target_position_changed(target_position)

func _ready():
	set_random_wait_time()
	change_target_position()

func _on_Timer_timeout():
	set_random_wait_time()
	change_target_position()

func set_random_wait_time():
	timer.wait_time = wait_time + rand_range(-wait_time_range, wait_time_range)

func change_target_position():
	var target_vector = Vector2(
		rand_range(-wander_range,wander_range),
		rand_range(-wander_range,wander_range)
	)
	target_position = starting_position + target_vector
	emit_signal("target_position_changed", target_position)
