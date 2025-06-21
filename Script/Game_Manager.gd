extends Node3D
class_name Game_Manager


#Loading assessts
#var Zombie := preload("res://Prefabs/Zombies/zombie.tscn")
var Sun := preload("res://Prefabs/sun.tscn")
var Sun_Script := preload("res://Script/sun.gd")
var Lawn_Mower := preload("res://Prefabs/lawn_mower.tscn")
var Wave := preload("res://Prefabs/Wave/wave.tscn")
var Mesh_Instancing := preload("res://Script/mesh_instances_manager.gd")
  
#Wave variables
var Level_Wave_Values:Dictionary = {"0":1,"1":1,"2":1,"3":1,"4":1,"5":2,"6":2,"7":3,"8":5,"9":10}
var Lanes:Dictionary
#var Total_Sun_In_Lane:Dictionary
var Zomb_Pool = Zombie

var skip_timer = false
signal timer_skipped

var Zombie_Rows_Tracker:Dictionary
#var Spawned_in = []
#var Grace_Period_Done
var current_Wave_Health

#Grid stuff
var Tile_Grid:Dictionary
var Zombie_Spawns:Dictionary
var Zombie_Spawns_Centers:Dictionary
var Sun_Spawns:Dictionary

var Grace_Period := 20 #Seconds

var Start := true

#mesh instancing

#func _ready():
	#gets Total Mesh pool
	#var Zombie_Instance_Amount = 0
	#print(Level_Wave_Values.values())
	#for Zombies in Level_Wave_Values.values():
		#print("Zombie wave value = ",Zombie_Instance_Amount)
	#	Zombie_Instance_Amount += Zombies
		#print("Zombie wave value = ",Zombie_Instance_Amount)
	#Mesh_Instancing.Set_Zombie_Instances(Zombie_Instance_Amount)

func _physics_process(delta) -> void:
	
	if Start == true and Zombie_Spawns.size() > 0:
		#print("zombie spawn greater than zero")
		Start = false
		#print("size = ", Zombie_Spawns.size())
		#await get_tree().create_timer(1).timeout
		Spawn_Mowers()
		print(len(Zombie_Rows_Tracker))
		Spawn_Sun()
		Play_Level()

func Get_Game_State() -> void:
	print(Tile_Grid)

func Get_Empty_Spaces() -> void:
	var temp
	for i in Tile_Grid:
		temp = Tile_Grid[i]
		#print(temp.Filled)

func Update_State(ID,Tile_Object) -> void:
	Tile_Grid.erase(ID)
	Tile_Grid[ID] = Tile_Object
	#Get_Empty_Spaces()

func Get_Spawns(List,Type) -> void:
	#var Zom_Dic:Dictionary
	for Tile in Tile_Grid:
		#print("looking in ", Tile)
		if Tile_Grid[Tile].Type == Type:
			List[List.size()] = Tile_Grid[Tile]
			#print("found it!!", List[List.size()-1])

func Spawn_Mowers() -> void:
	var Front_Column:Dictionary
	var Y_Offset := Vector3(0,0.2,1.75)
	for Tiless in Sun_Spawns:
		if Sun_Spawns[Tiless].X_Cord == 1:
			Front_Column[Front_Column.size()] = Sun_Spawns[Tiless]
	
	for Rows in Front_Column:
		var Mower_instantiate = Lawn_Mower.instantiate()
		Mower_instantiate.position = Front_Column[Rows].Center + Y_Offset
		add_child(Mower_instantiate)

#func Spawn_Zombie(Lane) -> void:

	#var random_num = randi() % (Zombie_Spawns.size())

	#var Spawn_Tile_Center = Zombie_Spawns[Lane].Center
	#var zombie_instance = Zombie.instantiate()
	#Zombie_Rows_Tracker[Lane].append(zombie_instance)
	#zombie_instance.position = Spawn_Tile_Center + Vector3(0,1,-1)
	
	#add_child(zombie_instance)

func Spawn_Sun() -> void:
	var random_num = randi() % (Sun_Spawns.size())
	var Spawn_Tile_Center = Sun_Spawns[random_num].Center
	var Sun_instance = Sun.instantiate()
	
	Sun_instance.position = Spawn_Tile_Center + Vector3(0,5,0)
	add_child(Sun_instance)
	#Despawn_Timer(Sun_instance,5)

func Despawn_Timer(Instance,Decay_Time) -> void:
	await get_tree().create_timer(Decay_Time).timeout
	if is_instance_valid(Instance):
		Instance.queue_free()
		Instance = null

func Play_Level():
	for wave in Level_Wave_Values:
		var random_time_waves = (randi() % (1)) + 5 #25-31 25
		var Wave_instance = Wave.instantiate()
		add_child(Wave_instance)
		Wave_instance.Zombie_Spawns = Zombie_Spawns_Centers
		#print("random time = ",random_time_waves)
		#print("----------","wave = ",wave,"----------")
		#print("Intial waves = ",len(Spawned_in))
		#print("wave worth = ",Level_Wave_Values[wave])
		#get_sun()
		
		await get_tree().create_timer(random_time_waves).timeout
		
		#timer
		#var timer = get_tree().create_timer(random_time_waves)
		
		# Wait for either the timer to timeout or be skipped
		#var timer_signal = await timer.timeout or await timer_skipped
		#if timer_signal == "timer_skipped":
		#	print("Timer skipped!")
		#else:
		#	print("Timer finished.")
		
		
		# Reset the skip flag for the next timer
		#skip_timer = false
		
		
		#print("lanes = ",Lanes) 
		#print("lane sun amount = ",get_sun())
		Wave_instance.Spawn_Wave(Level_Wave_Values[wave],get_sun())	

#func Spawn_Wave(Worth:int,Zomb_pool):
#	var Zomb_Value
#	var worth = Worth
#	
#	#get_sun()
#	
#	while worth >= 0: # Start at Worth, stop before -1, step down by -Zomb_Value
#		print("worth = ", worth)
#		if !Spawned_in.is_empty():
#			var random_initial_num = randi() % (Spawned_in.size())
#		
#			print("random_number = ", random_initial_num)
#			print("spawn lane number = ",Spawned_in[random_initial_num])
#			print("intial_lanes = ",Spawned_in,"length = ",len(Spawned_in))
#			Spawn_Zombie(Spawned_in[random_initial_num])
#			Spawned_in.remove_at(random_initial_num)
#		else:
#			var random_Lane = randi() % (Zombie_Spawns.size()) #number of lanes
#			var random_time = randf()/10
#			print("spawning lanes = ",Zombie_Spawns.size())
#			Spawn_Zombie(random_Lane)
#			#await get_tree().create_timer(random_time).timeout
#		Zomb_Value = 1
#		worth =- Zomb_Value

func get_sun():
	var Total_Sun_In_Lane:Dictionary
	for lane in Lanes:
		Total_Sun_In_Lane[lane] = 0
		for tile in Lanes[lane]:
			#print("this is the GET_SUN FUNCTION")
			#print("lane = ",lane,"tile = ",tile)
			var plant
			for child in tile.get_children():
				if child is Plant:
					plant = child
					#print("plant = ",plant,"cost = ",plant.Cost)
					if !Total_Sun_In_Lane.has(lane):
						Total_Sun_In_Lane[lane] = plant.Cost
					else:
						Total_Sun_In_Lane[lane] += plant.Cost
			
		#print("lane length = ",len(Lanes[lane]))
	return Total_Sun_In_Lane

func skip_timer_action():
	skip_timer = true
	emit_signal("timer_skipped")
