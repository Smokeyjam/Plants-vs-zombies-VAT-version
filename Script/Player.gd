extends Camera3D
class_name Player

enum States{COLLECTING,PLANTING}
var Current_Sate = States.COLLECTING

@onready var Sun_Script = preload("res://Script/sun.gd")

@onready var Seed_Slot
@onready var Selected_Plant:PackedScene
@onready var Placing_Plant:PackedScene

@onready var UI =  %UI

@export var target_distance := 5
@export var target_height := 10

@onready var marker = %Mouse_pos

var Collided_Object

var follow_this
var last_lookat

func _input(event) -> void:
	if event is InputEventMouseMotion:
		Mouse_Marker()

func _physics_process(delta) -> void:
	#controls
	#place plant on selected tile
	if Current_Sate == States.PLANTING:
		#print("planting")
		#marker.visible = true
		Planting()
	elif Current_Sate == States.COLLECTING:
		Collecting()
	
	#camera stuff
	Camera_follow(delta)

func Camera_follow(delta):
	#camera stuff
	var delta_v = global_transform.origin - follow_this.global_transform.origin
	var target_pos = global_transform.origin
	# ignore y
	delta_v.y = 0.0
	
	if (delta_v.length() > target_distance):
		delta_v = delta_v.normalized() * target_distance
		delta_v.y = target_height
		target_pos = follow_this.global_transform.origin + delta_v
	else:
		target_pos.y = follow_this.global_transform.origin.y + target_height
	
	global_transform.origin = global_transform.origin.lerp(target_pos, delta * 20.0)
	
	last_lookat = last_lookat.lerp(follow_this.global_transform.origin, delta * 20.0)
	
	look_at(last_lookat, Vector3(0.0, 1.0, 0.0))

func Mouse_Marker() -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_length = 300
	var from = project_ray_origin(mouse_pos)
	var to = from + project_ray_normal(mouse_pos) * ray_length
	var space = get_world_3d(). direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = from
	ray_query.to = to
	var raycast_result = space.intersect_ray(ray_query)

	if !raycast_result.is_empty():
		Collided_Object = raycast_result["collider"]
		if Current_Sate == States.PLANTING:
			Planting_Hover(raycast_result["position"])
			marker.visible = true
		else:
			marker.visible = false

func Collecting() -> void:
	if !Input.is_action_pressed("Place_Plant"):
		return
	if !is_instance_valid(Collided_Object):
		return
	if !Collided_Object is Sun:
		return

	Collided_Object.Collect()
	Collided_Object.Despawn_Timer(Collided_Object,0)
	Collided_Object = null
	UI.Update_Sun()

func Planting() -> void:
	
	if Input.is_action_pressed("Exit_Placing"):
		Current_Sate = States.COLLECTING
		print("exit")
	
	if !Input.is_action_pressed("Place_Plant"):
		return
	if !Collided_Object is Tile:
		return
	if Collided_Object.Filled:
		return
	if !Collided_Object.Type == Map.Tile_Type.GRASS:
		return
	if !Seed_Slot.Plant_Cost <= Sun_Script.Total_Sun:
		return
	
	Sun_Script.Total_Sun -= Seed_Slot.Plant_Cost
	UI.Update_Sun()
	
	var Placed_Plant = Collided_Object.Place_Plant(Selected_Plant)
	Seed_Slot.On_Cooldown = true
	Seed_Slot.Cooldown() 
	Current_Sate = States.COLLECTING

func Planting_Hover(raycast_result) -> void:
	if Collided_Object is Tile and Collided_Object.Filled == false and Collided_Object.Type == Map.Tile_Type.GRASS:
		marker.position = Collided_Object.Center
	else:
		marker.position = raycast_result

func update_placing_indicator():	
	
	if marker.get_children():
		for child in marker.get_children():
			child.queue_free()
	
	#marker.visible = true
	var indicator_instance = Placing_Plant.instantiate()
	marker.add_child(indicator_instance)
	print(indicator_instance)


#func get_mesh_from_plant_prefab() -> void:
	# Ensure the instance is valid and contains a MeshInstance3D
#	var mesh_instance = Selected_Plant.instantiate()
	#find Skeleton3D node
#	for child in mesh_instance.get_children():
#		if child is Skeleton3D:
#			Armature = child
#		else:
#			print("no Armature found in seed slot")
	#find Meshinstance bode
#	for child in mesh_instance.get_children():
#		if child is MeshInstance3D:
#			Plant_Mesh = child
			
#		else:
#			print("no mesh found in seed slot")
#	mesh_instance.queue_free()
