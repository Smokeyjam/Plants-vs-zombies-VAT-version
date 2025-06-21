extends VehicleBody3D

############################################################
#Getting Wheel Nodes
#got them, just have to change variable to make them drift

############################################################
# behaviour values

@export var MAX_ENGINE_FORCE = 200.0
@export var MAX_BRAKE_FORCE = 5.0
@export var MAX_STEER_ANGLE = 0.5

@export var steer_speed = 5.0

var steer_target = 0.0
var steer_angle = 0.0

############################################################
# Input

@export var joy_steering = JOY_AXIS_LEFT_X
@export var steering_mult = -1.0
@export var joy_throttle = JOY_AXIS_TRIGGER_RIGHT
@export var throttle_mult = 1.0
@export var joy_brake = JOY_AXIS_TRIGGER_LEFT
@export var brake_mult = 1.0

#Extra input
@export var Grip = 100
@export var Grip_Drift = 1
var Boost = 1

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _physics_process(delta):
	var steer_val = steering_mult * Input.get_joy_axis(0, joy_steering)
	var throttle_val = throttle_mult * Input.get_joy_axis(0, joy_throttle)
	var brake_val = brake_mult * Input.get_joy_axis(0, joy_brake)
	
	# overrules for keyboard
	if Input.is_action_pressed("Throttle"):
		throttle_val = 1.0
	if Input.is_action_pressed("Reverse"):
		throttle_val = -1.0
	if Input.is_action_pressed("Brake"):
		brake_val = 1.0
	if Input.is_action_pressed("Turn_Left"):
		steer_val = 1.0
	elif Input.is_action_pressed("Turn_Right"):
		steer_val = -1.0
	#Drift
	if Input.is_key_pressed(KEY_CTRL):
		%Rear_Right.wheel_friction_slip = Grip_Drift
		%Rear_Left.wheel_friction_slip = Grip_Drift
		#print("CTRL pressed!!!")
	else:
		%Rear_Right.wheel_friction_slip = Grip
		%Rear_Left.wheel_friction_slip = Grip
	#Boost
	if Input.is_key_pressed(KEY_SHIFT):
		Boost = 2
		#print("shift pressed!!!")
	else: 
		Boost = 1
	#%Rear_Right.wheel_friction_slip = 100
	#%Rear_Left.wheel_friction_slip = 100
	
	engine_force = throttle_val * MAX_ENGINE_FORCE * Boost
	brake = brake_val * MAX_BRAKE_FORCE
	
	steer_target = steer_val * MAX_STEER_ANGLE
	if (steer_target < steer_angle):
		steer_angle -= steer_speed * delta
		if (steer_target > steer_angle):
			steer_angle = steer_target
	elif (steer_target > steer_angle):
		steer_angle += steer_speed * delta
		if (steer_target < steer_angle):
			steer_angle = steer_target
	
	steering = steer_angle
