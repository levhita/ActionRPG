extends Camera2D

onready var topLeft = $Limits/TopLeft.position
onready var bottomRight = $Limits/BottomRight.position

func _ready():
	limit_top = topLeft.y
	limit_left = topLeft.x
	limit_bottom = bottomRight.y
	limit_right = bottomRight.x
