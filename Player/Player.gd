extends KinematicBody2D

const HurtSound = preload("res://Player/HurtSound.tscn")

# Frames as in 60fps
export var MAX_SPEED = 80
# Acceleration and friction is the same thing because of the algorithm below
onready var ACCELERATION = MAX_SPEED * 8 # 1/8 of a second
export(float) var ROLL_SPEED = 1.25
export(float) var DAMAGE = 1

export(Vector2) var START_VECTOR = Vector2.DOWN
onready var roll_vector = START_VECTOR

var velocity = Vector2.ZERO

enum {
	MOVE,
	ROLL,
	ATTACK
}
var state = MOVE

var stats = PlayerStats
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get('parameters/playback')
onready var swordHitbox = $HitboxPivot/Hitbox
onready var blink = $Blink

func _ready():
	stats.connect("no_health",self, "die")
	animationTree.active = true
	swordHitbox.damage = DAMAGE

	animationTree.set("parameters/Idle/blend_position", START_VECTOR)
	animationTree.set("parameters/Run/blend_position", START_VECTOR)
	animationTree.set("parameters/Attack/blend_position", START_VECTOR)
	animationTree.set("parameters/Roll/blend_position", START_VECTOR)

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state(delta)
		ATTACK:
			attack_state(delta)

func move_state(delta):
	var input_vector = Vector2.ZERO

	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left") 
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	# Force applied and resistance when zero input given
	velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	velocity = velocity.clamped(MAX_SPEED)
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector.normalized()
		swordHitbox.knockback_vector = input_vector.normalized()
		
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel('Run')
	else:
		animationState.travel('Idle')
	# Move	
	velocity = move_and_slide(velocity)

	if Input.is_action_just_pressed("ui_accept"):
		state = ATTACK
		animationState.travel('Attack')
	if Input.is_action_just_pressed("ui_cancel"):
		state = ROLL
		animationState.travel('Roll')

func attack_state(delta):
	velocity = velocity.move_toward(Vector2.ZERO, ACCELERATION * delta)
	velocity = move_and_slide(velocity)

func roll_state(delta):
	# instantly acchieves max speed
	velocity = roll_vector.clamped(1) * MAX_SPEED * ROLL_SPEED
	velocity = move_and_slide(velocity)

func die():
	queue_free()
	
func attack_animation_finished():
	state = MOVE
	animationState.travel('Idle')

func roll_animation_finished():
	state = MOVE
	velocity = velocity / 2
	animationState.travel('Idle')

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	get_parent().add_child(HurtSound.instance())

func _on_Hurtbox_invincibility_started():
	blink.play("Start")
	pass


func _on_Hurtbox_invincibility_finished():
	blink.play("Stop")
	pass
