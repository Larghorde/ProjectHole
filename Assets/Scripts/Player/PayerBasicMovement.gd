extends CharacterBody3D


@export var defaultSpeed:float = 5.0
@export var runMultiplier:float = 2.0
@export var JUMP_VELOCITY:float = 6.5
@export var turn_speed = 10
var speed = defaultSpeed
var isRunning:bool = false

@onready var axis = Vector3.ZERO 

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	axis.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	var direction = (transform.basis * Vector3(axis.x, 0, 0)).normalized()
	if Input.is_action_pressed("run"):
		speed = defaultSpeed * runMultiplier
		isRunning = true
	else:
		speed = defaultSpeed
		isRunning = false
	if direction:
		velocity.x = direction.x * speed
		$TestPlayerV2.rotation.y = lerp_angle($TestPlayerV2.rotation.y, atan2(direction.x, direction.z), delta * turn_speed)
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	$AnimationTree.set("parameters/conditions/idle", axis.x == 0 && is_on_floor())
	$AnimationTree.set("parameters/conditions/walk", !isRunning && axis.x != 0 && is_on_floor())
	$AnimationTree.set("parameters/conditions/falling", !is_on_floor())
	$AnimationTree.set("parameters/conditions/landed", is_on_floor())
	$AnimationTree.set("parameters/conditions/jump",  Input.is_action_just_pressed("jump") && is_on_floor())
	$AnimationTree.set("parameters/conditions/run",  isRunning && axis.x != 0 && is_on_floor())

	move_and_slide()
