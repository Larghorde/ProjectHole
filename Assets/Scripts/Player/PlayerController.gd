extends CharacterBody3D

class_name PlayerController

@onready var animation = AnimationController.new()

@export var defaultSpeed:float = 5.0
@export var runMultiplier:float = 2.0
@export var jumpVelocity:float = 6.5
@export var turnSpeed:float = 10
var speed:float = defaultSpeed


var isRunning:bool = false
var isGrounded:bool = true
var isJumping:bool = false

@onready var axis:Vector3 = Vector3.ZERO 

@onready var animationTree:AnimationTree = $AnimationTree


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta):
	ApplyPhysics(delta)
	InputDetection(delta)

#Handles player physics
func ApplyPhysics(delta):
	isGrounded = is_on_floor()
	
	# Add the gravity.
	if !isGrounded:
		velocity.y -= gravity * delta
		
		# Handle jump.
	if isJumping && isGrounded:
		velocity.y = jumpVelocity
	

#Checks input and applies movement
func InputDetection(delta):
	
	#Check Jump
	if Input.is_action_just_pressed("jump"):
		isJumping = true
	else:
		isJumping = false
		

	# Get the input direction and handle the movement/deceleration
	axis.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	
	var direction = (transform.basis * Vector3(axis.x, 0, 0)).normalized()
	
	#Check for Run and multiplies speed
	if Input.is_action_pressed("run"):
		speed = defaultSpeed * runMultiplier
		isRunning = true
	else:
		speed = defaultSpeed
		isRunning = false
		
	if direction:
		velocity.x = direction.x * speed
		# Rotate Player
		$Player.rotation.y = lerp_angle($Player.rotation.y, atan2(direction.x, direction.z), delta * turnSpeed)
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	#Play Animations
	animation.PlayerAnimations(self, axis, isRunning, isGrounded,isJumping)

	move_and_slide() 
