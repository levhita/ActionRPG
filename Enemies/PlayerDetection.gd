extends Area2D

var player = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func can_see_player():
	return player != null

func _on_PlayerDetection_body_entered(body):
	player = body


func _on_PlayerDetection_body_exited(body):
	player = null
