extends Node3D
class_name Health_Component

@export var MAX_HEALTH = 181 #(is health for base zombie)
#@export var EXTRA_HEALTH = 89 #this is a zombie thing

@export var mesh : MeshInstance3D
@export var particles : GPUParticles3D
@export var Hitbox : Area3D
#@export var PlantID : int  = get_parent().ID

#@onready var Mesh_Instance_Manager:Node3D = get_node("/root/Main/Mesh_Instances_Manager")
#@onready var multi_instance_mesh:VATMultiMeshInstance3D = Mesh_Instance_Manager.get_Mesh_Instancer(get_parent().ID) 

var health:int 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = MAX_HEALTH # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func damage(attack: Attack) -> void:
	health -= attack.attack_damage
	
	if health <= 0:
		mesh.visible = false
		particles.emitting = true
		Hitbox.queue_free()
		get_parent().get_parent().Plant_Destroyed() #so you can place a plant again on the same tile
		#await get_tree().create_timer(1).timeout
		get_parent().queue_free()
