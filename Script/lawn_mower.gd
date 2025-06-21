extends Node3D
class_name Lawn_Mower 

@onready var Map_initiator:= preload("res://Script/Map_initiator.gd")

@export var Seconds_Per_Grid := 0.2
@export var Detection_Range := 1

var Moving:bool = false
var attack_damage = 10000
var Kill_Wall:float

#var parameters := PhysicsRayQueryParameters3D.new()

func _ready():
	Kill_Wall = Map_initiator.Kill_Wall_Z

func _physics_process(delta):
	if In_Range():
		Moving = true
	
	if Moving == true:
		move()
		
	if self.position.z <= -Kill_Wall:
		queue_free()

func move():
	var Ticks_Per_Grid = Seconds_Per_Grid * Engine.physics_ticks_per_second
	var Movement_speed = 2 / (Ticks_Per_Grid)
	self.position = self.position + Vector3(0,0,-Movement_speed)

func In_Range() -> bool:
	
	var Zombies_Collided_With = Draw_Raycast()
	
	
	if !Zombies_Collided_With.is_empty() and Zombies_Collided_With[0].collider is Hitbox_Component:
		
		return true
	else:
		return false

func Kill_Zombie(raycast_result):
	
	var hitbox = raycast_result.collider
	var attack = Attack.new()
	attack.attack_damage = attack_damage
	attack.lawn_mower = true
	hitbox.damage(attack)
	hitbox.get_parent().queue_free()


func Draw_Raycast():
	var from = self.global_position
	var to =  self.global_position - Vector3(0,0,Detection_Range)
	var space = get_world_3d(). direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = from
	ray_query.to = to
	ray_query.collide_with_areas = true
	ray_query.collide_with_bodies = false
	ray_query.exclude = [self]

	var exclude: Array[RID] = [] # Array that holds RIDs of already hit colliders
	var direct_space: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state

	#var max_collected_colliders: int = 5
	var collected_colliders: Array = []

	for i in range(collected_colliders.size()):
		ray_query.exclude = exclude # Update parameters with already hit colliders.
		var result = direct_space.intersect_ray(ray_query)
		if result:
			exclude.push_back(result.rid) # Exclude hit collider for next ray.
			collected_colliders.push_back(result)
			
	#print(collected_colliders)

	return collected_colliders
#func _on_damage_component_area_entered(area):
	#print("lawn mower hit")
	#_physics_process(true)
	
#var objects_collide = [] #The colliding objects go here.
#while ray.is_colliding():
	#var obj = ray.get_collider() #get the next object that is colliding.
	#objects_collide.append( obj ) #add it to the array.
	#ray.add_exception( obj ) #add to ray's exception. That way it could detect something being behind it.
	#ray.force_raycast_update()
