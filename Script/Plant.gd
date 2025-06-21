extends Node3D
class_name Plant #extends Map

#signal Plant_On_Cooldown

@onready var Mesh_Instance_Manager:Node3D = get_node("/root/Main/Plants_Mesh_Instances_Manager")

@export var particles : GPUParticles3D

@export var ID:int
@export var Cost:int
@export var Cooldown_Place:float
@export var Cooldown_Shoot:float
var is_enbled:bool = true
var Shoot_Ready:bool = true

#shooting stuff
@onready var Gun_anim:= $AnimationTree
@onready var Bullet:PackedScene
@onready var Map_initiator:= preload("res://Script/Map_initiator.gd")
@onready var gun_barrel:= $Barrel

var Bullet_Instance

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#smoke
	#if is_enbled == true:
	#	particles.emitting = true
	#	await get_tree().create_timer(1).timeout
	#	particles.emitting = false
	#else:
	#	particles.queue_free()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _physics_process(delta: float) -> void:
	#Shoot()

func Shoot() -> void:

	if Shoot_Ready == true and is_enbled == true and get_parent() is Tile:
		var instance = Mesh_Instance_Manager.Mesh_Instance_Dict[ID]
		var multimesh = instance.multimesh
		var tile_ID = get_parent().ID
		#print("multimesh = ", Mesh_Instance_Manager.Mesh_Instance_Dict[ID])
		#print("id = ", ID)
		var custom_data = multimesh.get_instance_custom_data(tile_ID)
		
		#print("custom_data = ", custom_data)
		#Gun_anim.set("parameters/Shoot_/request",AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		#Gun_anim.call_deferred("set", "request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		# Stretch when shooting
		
		
		#print ("plant ID Shooting = ", tile_ID)
		custom_data.r = 1.0  # activate animation
		multimesh.set_instance_custom_data(tile_ID, custom_data)
		
		Shoot_Ready = false
		Bullet_Instance = Bullet.instantiate()
		Bullet_Instance.position = gun_barrel.global_position
		Bullet_Instance.transform.basis = gun_barrel.global_transform.basis
		get_parent().get_parent().add_child(Bullet_Instance)
		#Gun_anim.get_current_animation_length()
		var animation_time = Cooldown_Shoot/10
		await get_tree().create_timer(animation_time*2).timeout
		custom_data.r = 0.0  # deactivate animation
		multimesh.set_instance_custom_data(tile_ID, custom_data)
		await get_tree().create_timer(animation_time*8).timeout
		Shoot_Ready = true
		

		#material.set_shader_param("squash_amount", lerp(material.get_shader_param("squash_amount"), 0.0,10))
		
func disable():
	is_enbled = false
	#print("DISABLED")
