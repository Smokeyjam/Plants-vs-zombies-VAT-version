class_name Tile extends Game_Manager

var ID:int 
var X_Cord:int
var Y_Cord:int
var Type:int
var Filled:bool = false

var Plant_intance
var Center

#@onready var mesh_instancer: VATMultiMeshInstance3D = get_node("/root/Main/Mesh_Instances_Manager/VATMultiMeshInstance3D")
#@onready var Mesh_Instance_Manager:Node3D = %Mesh_Instances_Manager
@onready var Mesh_Instance_Manager:Node3D = get_node("/root/Main/Plants_Mesh_Instances_Manager") # Adjust path as needed


func Create_Tile() -> void:
	var Tile_Side_Length := 2
	var Tile_pos := Vector3(Y_Cord*Tile_Side_Length,0,-X_Cord*Tile_Side_Length)
	self.position = Tile_pos
	self.Center = Tile_pos

func Place_Plant(Plant_Object) -> Node3D:
	Plant_intance = Plant_Object.instantiate() 

	var origin = self.global_transform.origin
	var rotation = Vector3(0, 0, 45)
	var scale = Vector3(0.02, 0.31, 0.31)
	print ("plant instance ID Shooting = ", Plant_intance.ID)
	Transform_Multi_Mesh(origin, rotation, scale,Plant_intance.ID)

	#mesh_instancer.multimesh.set_ = Vector3(0.02,0.2,0.2)
	add_child(Plant_intance)
	
	Filled = true
	Update_State(ID,self)
	
	#Plant_intance.Cooldown()
	return Plant_intance

func Plant_Destroyed():

	Transform_Multi_Mesh(Vector3(0,0,0), Vector3(0, 0, 45), Vector3(0.02, 0.31, 0.31),Plant_intance.ID)
	
	Filled = false
	Update_State(ID,self)

func Transform_Multi_Mesh(origin: Vector3, rotation: Vector3, scale: Vector3,key: int):
	var mesh_instancer = Mesh_Instance_Manager.get_Mesh_Instancer(Plant_intance.ID)
	var mesh_transform = make_scaled_rotated_transform(origin, rotation, scale)
	mesh_instancer.multimesh.set_instance_transform(self.ID, mesh_transform)

func make_scaled_rotated_transform(origin: Vector3, rotation_deg: Vector3, scale: Vector3) -> Transform3D:
	# Convert degrees to radians
	var rotation_rad = rotation_deg * deg_to_rad(1.0)

	# Scale first
	var scaled_basis = Basis().scaled(scale)

	# Then apply rotation
	var rotation_basis = Basis()
	rotation_basis = rotation_basis.rotated(Vector3.RIGHT, rotation_rad.x)
	rotation_basis = rotation_basis.rotated(Vector3.UP, rotation_rad.y)
	rotation_basis = rotation_basis.rotated(Vector3.BACK, rotation_rad.z)

	# Combine them: rotation * scale = scale first, then rotate
	var final_basis = rotation_basis * scaled_basis

	# Return the final transform
	return Transform3D(final_basis, origin)
