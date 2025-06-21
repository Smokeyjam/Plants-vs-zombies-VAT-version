extends Node3D
class_name Zombie

@export var Zom_Health_Component : Zombie_Health_Component
@export var Zom_ID : int
@export var Seconds_Per_Grid := 4.7 - 0.8 #4.7 is base zombie speed from wiki -0.8 is the time within the animation to move
											#lower is faster

@onready var Zom_anim:= $AnimationTree
@export var Worth := 1
@export var Preference := 0.4

#var timer
var Stood_still = false

var Attacking := false
var Dead := false
var Ticks_Per_Grid:float
var Movement_speed:float

var Time_After_Death := 2 
var poison_damage 
var attack:Attack

#func _ready():    
	# Start a timer to check the current frame periodically
	#timer = Timer.new()
	#timer.wait_time = 0.6 * 2.5
	#timer.autostart = true
	#timer.one_shot = false
	#timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	#add_child(timer)

func Still():
	Stood_still = true

func Moving():
	Stood_still = false	

func Attackin(status:bool):
	if status == true:
		Attacking = true
		Zom_anim.set("parameters/Eat/request",AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	else:
		Attacking = false
		Zom_anim.set("parameters/Eat/request",AnimationNodeOneShot.ONE_SHOT_REQUEST_FADE_OUT)

func Died():
	Seconds_Per_Grid = Seconds_Per_Grid * 2
	Dead = true

func Died_animation():
	Seconds_Per_Grid = 0
	Zom_anim.set("parameters/Die/request",AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)

func _physics_process(delta) -> void:

	if Attacking == false and Stood_still == false:
		Move()
	
	if Dead == true and Zom_Health_Component:
		poison_damage = Zom_Health_Component.EXTRA_HEALTH / (Time_After_Death * Engine.physics_ticks_per_second)
		var attack = Attack.new()
		attack.attack_damage = poison_damage
		Zom_Health_Component.damage(attack)
		#print("dealt poison damage")

func Move() -> void:
	Ticks_Per_Grid = (Seconds_Per_Grid * Engine.physics_ticks_per_second)
	Movement_speed = (2 / (Ticks_Per_Grid)) #* 2.75 #(animation length = 1.6s extended tp 4s 1.1 walking 1.1 * 2.5 = 2.75 )
	self.position = self.position + Vector3(0,0,Movement_speed)
