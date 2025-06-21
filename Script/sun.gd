extends Node3D
class_name Sun

static var Total_Sun:int = 100000

@export var Value:int = 25
@export var Sun_Radius := 0.5
@export var Seconds_Per_Grid:float = 2

var Grounded:bool = false

func _ready():
	Despawn_Timer(self,5)

func Collect() -> void:
	Total_Sun += Value

func _physics_process(delta):
	if !Ground():
		Move()

func Move() -> void:
	var Ticks_Per_Grid := Seconds_Per_Grid * Engine.physics_ticks_per_second
	var Movement_speed := 2 / (Ticks_Per_Grid)
	self.position = self.position - Vector3(0,Movement_speed,0)

func Ground() -> bool:
	var from = self.global_position - Vector3(0,Sun_Radius,0)
	var to =  self.global_position - Vector3(0,Sun_Radius*1.1,0)
	var space = get_world_3d(). direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = from
	ray_query.to = to
	#ray_query.collide_with_areas = true
	var raycast_result = space.intersect_ray(ray_query)
	if !raycast_result.is_empty():
		#print("Sun hit ground")
		return true
	else:
		return false

#func Die() -> void: #Unused 
	#await get_tree().create_timer(Decay_Time).timeout
	#queue_free()
	
func Despawn_Timer(Instance,Decay_Time) -> void:
	if !Decay_Time <= 0:
		await get_tree().create_timer(Decay_Time).timeout
	
	if is_instance_valid(Instance):
		Instance.queue_free()
		Instance = null
