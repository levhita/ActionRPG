extends Control

var max_health = 4 setget set_max_health
onready var health = max_health setget set_health

onready var hearts = $Hearts
onready var emptyHearts = $EmptyHearts

func set_health(value):
	health = value
	if hearts != null:
		hearts.rect_size.x = 15 * health

func set_max_health(value):
	max_health = value
	if emptyHearts != null:
		emptyHearts.rect_size.x = 15 * max_health

func _ready():
	self.max_health = PlayerStats.max_health
	self.health = PlayerStats.health
	PlayerStats.connect("health_change", self, "set_health")
	PlayerStats.connect("max_health_change", self, "set_max_health")
	
