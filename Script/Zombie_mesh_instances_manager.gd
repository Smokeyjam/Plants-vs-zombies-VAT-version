extends Node3D

var Zombie_Mesh_Instance_Dict := {}  # key: Zombie_id (int or string), value: PackedScene or instance

#@onready var vat_multi_mesh_instance_3d: VATMultiMeshInstance3D = %VATMultiMeshInstance3D
var node3D: Node3D = Node3D.new()
var location: Vector3 = Vector3.ZERO

#to get number of tiles
@onready var Map_Script = preload("res://Script/Map_initiator.gd")

var x: float = 0
var z: float = 0

func _ready() -> void:
	# setup all instances
	setupInstances()

func setupInstances():
	var a: int = 0 # animation track number
	var i = 0
	#var dict_num = Mesh_Instance_Dict.keys()[i]
	
	print("num of tiles = ", Map_Script.Number_Of_Tiles)
	for items in Zombie_Mesh_Instance_Dict:
		var dict_num = Zombie_Mesh_Instance_Dict.keys()[i]
		i += 1
		
		print("key = ",dict_num)
		var vat_multi_mesh_instance_3d = Zombie_Mesh_Instance_Dict[dict_num]
		# Access the VATMultiMeshInstance3D inside the instance
		print("item in dict = ",vat_multi_mesh_instance_3d)
		# Set instance count
		
		vat_multi_mesh_instance_3d.multimesh.instance_count = Map_Script.Number_Of_Tiles
		# Optionally add to scene if not already added
		
		
		for instance in vat_multi_mesh_instance_3d.multimesh.instance_count:
			# randomize the animation offset
			vat_multi_mesh_instance_3d.update_instance_animation_offset(instance, randf())
			# set the animation track number
			vat_multi_mesh_instance_3d.update_instance_track(instance, a)
			# set alpha to 1.0 -> you can fade out a specific instance by setting alpha to 0
			vat_multi_mesh_instance_3d.update_instance_alpha(instance, 1.0)
			# randomize scale, rotation, and location
			placeInstance(vat_multi_mesh_instance_3d,instance)
			
			# Unit tests for helper functions - you can comment this out
			#print("Instance: ", instance, "   Track: ", vat_multi_mesh_instance_3d.get_track_number_from_instance(instance), \
				#"   Frame Start/End:", vat_multi_mesh_instance_3d.get_start_end_frames_from_instance(instance), \
				#"   Test Vector2i: ", vat_multi_mesh_instance_3d.get_start_end_frames_from_track_number(a) == vat_multi_mesh_instance_3d.get_start_end_frames_from_instance(instance), \
				#"   Test Track: ", vat_multi_mesh_instance_3d.get_track_number_from_track_vector(vat_multi_mesh_instance_3d.get_start_end_frames_from_track_number(a)) == vat_multi_mesh_instance_3d.get_track_number_from_instance(instance))
			
			print("VAT Plants initialised")
			
			# this cycles threw each animation track number
			a += 1
			if a > vat_multi_mesh_instance_3d.number_of_animation_tracks - 1:
				a = 0

func placeInstance(vat_multi_mesh_instance,i: int):
	location.x = x
	location.z = z
	location.y = 1
	
	node3D.scale = Vector3(0.02,0.2,0.2)
	
	node3D.rotation = Vector3.ZERO
	node3D.position = location
	
	#var custom_data = vat_multi_mesh_instance.multimesh.get_instance_custom_data(i)
	#custom_data.r = 0.0  # or 1.0 to disable squash/stretch
	vat_multi_mesh_instance.multimesh.set_instance_transform(i, node3D.transform)
	#vat_multi_mesh_instance.multimesh.set_instance_custom_data(i, custom_data)

func get_Mesh_Instancer(key):
	#print(Mesh_Instance_Dict[key])
	return Zombie_Mesh_Instance_Dict[key]; 

func _process(_delta: float) -> void:
	pass

func Transform_Multi_Mesh(origin: Vector3, rotation_deg: Vector3, scale: Vector3,key: int):
	var mesh_instancer = Zombie_Mesh_Instance_Dict[key]
	var mesh_transform = make_scaled_rotated_transform(origin, rotation, scale)
	mesh_instancer.multimesh.set_instance_transform(self.ID, mesh_transform)
	#mesh_instancer.update_instance_animation_offset(self.ID, randf())
	
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
