extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

export var ACCELERATION = 300
export var MAX_SPEED = 40
export var FRICTION = 100

export(String, "default", "strong") var SPRITE_ANIMATION = "default"

enum {
	IDLE,
	WANDER,
	CHASE
}
var state = WANDER

var knockback_vector = Vector2.ZERO
var velocity = Vector2.ZERO

onready var stats = $Stats
onready var playerDetection = $PlayerDetection
onready var detectionShape = $PlayerDetection/CollisionShape2D
onready var sprite = $AnimatedSprite
onready var wanderController = $WanderController
onready var blink = $Blink
onready var hitbox = $Hitbox

func _ready():
	sprite.animation = SPRITE_ANIMATION
	if SPRITE_ANIMATION == "strong":
		hitbox.damage = 2
		stats.health = 4
		MAX_SPEED = 70
		detectionShape.shape.radius += 100 
	
func _physics_process(delta):
	knockback_vector = knockback_vector.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback_vector = move_and_slide(knockback_vector)
	
	match state:
		IDLE:
			idle_state(delta) 
		WANDER:
			wander_state(delta)
		CHASE:
			chase_state(delta)
	
	velocity = move_and_slide(velocity)

func idle_state(delta):
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	if playerDetection.can_see_player():
		state = CHASE

func wander_state(delta):
	if global_position.distance_to(wanderController.target_position) < 4:
		state = IDLE
		return
	
	var direction = global_position.direction_to(wanderController.target_position)
	velocity = velocity.move_toward(direction * MAX_SPEED/2, ACCELERATION * delta)
	sprite.flip_h =velocity.x < 0
	
	if playerDetection.can_see_player():
		state = CHASE

func chase_state(delta):
	var player = playerDetection.player
	if player != null:
		var direction = global_position.direction_to(player.global_position)
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
		sprite.flip_h =velocity.x < 0
	else:
		state = WANDER

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	knockback_vector = area.knockback_vector * 120
	
func _on_Stats_no_health():
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.position = position
	queue_free()


func _on_WanderController_target_position_changed(target_position):
	if state == WANDER or state == IDLE:
		state = WANDER
		target_position = target_position


func _on_Hurtbox_invincibility_started():
	blink.play("Start")


func _on_Hurtbox_invincibility_finished():
	blink.play("Stop")
