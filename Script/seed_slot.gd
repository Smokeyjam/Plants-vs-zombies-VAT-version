extends TextureButton

@export var Plant_Prefab:PackedScene
@export var Plant_Mesh:PackedScene
#for mesh instancing#
#manager
#plant

@onready var Mesh_Instance_Manager:Node3D = get_node("/root/Main/Plants_Mesh_Instances_Manager")
@export var vat_multi_mesh_instance_3d:PackedScene

var Plant_Cost:int
var Plant_Cooldown:float
var On_Cooldown := false

@onready var Cooldown_Timer := $Timer
@onready var Player_Node := %Player
@onready var Cooldown_Bar := $TextureProgressBar

func _ready() -> void:
	var instance = Plant_Prefab.instantiate()
	#instance.global_position = Vector3(1,-100,1)
	add_child(instance)
	Plant_Cooldown = instance.Cooldown_Place
	Plant_Cost = instance.Cost
	
	
	var mesh_instance = vat_multi_mesh_instance_3d.instantiate()
	#Mesh_Instance_Manager.Mesh_Instance_List.append(mesh_instance)
	print("Seed_slot ID = ",instance.ID)
	Mesh_Instance_Manager.Mesh_Instance_Dict[instance.ID] = mesh_instance
	Mesh_Instance_Manager.add_child(mesh_instance)
	
	instance.queue_free()
	set_process(false)
# Called when the node enters the scene tree for the first time.

func _process(delta) -> void:
	Cooldown_Bar.value = Cooldown_Timer.time_left

func _on_pressed() -> void:
	if On_Cooldown == false and Plant_Cost <= Player_Node.Sun_Script.Total_Sun:
		Player_Node.Selected_Plant = Plant_Prefab
		Player_Node.Placing_Plant = Plant_Mesh
		Player_Node.Current_Sate = Player_Node.States.PLANTING 
		Player_Node.update_placing_indicator()
		Player_Node.Seed_Slot = self

func Cooldown() -> void:
	Cooldown_Timer.wait_time = Plant_Cooldown
	Cooldown_Bar.max_value = Plant_Cooldown
	Cooldown_Timer.start()
	set_process(true)

func _on_timer_timeout() -> void:
	On_Cooldown = false
	set_process(false) # Replace with function body.

#func get_mesh_from_plant_prefab(plant_instance) -> void:
	# Ensure the instance is valid and contains a MeshInstance3D
	#var mesh_instance = plant_instance
	#find Skeleton3D node
	#for child in mesh_instance.get_children():
	#	if child is Skeleton3D:
	#		Armature = child
	#	else:
	#		print("no Armature found in seed slot")
	#find Meshinstance bode
	#for child in mesh_instance.get_children():
	#	if child is MeshInstance3D:
	#		plant_mesh = child
	#	else:
	#		print("no mesh found in seed slot")
