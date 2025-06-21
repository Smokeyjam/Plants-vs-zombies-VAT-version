class_name Wave extends Node3D

#var Wave_Worth
var Zomb_Pool := [preload("res://Prefabs/Zombies/Brown_Coat/zombie.tscn"),
preload("res://Prefabs/Zombies/Cone_Head/zombie_ConeHead.tscn")]
#var lane_cost

#wave variables
var Zomb_Values = []
var Zomb_Value
var Zomb_Pick_Preference = []
var Zombie_Spawns:Dictionary
var Zombies_Spawned:Dictionary
var wave_health:int = 0 
var FiftyFiftyRule 

# Called when the node enters the scene tree for the first time.
func _ready():
	var zombie_instance
	for i in Zomb_Pool.size():
		zombie_instance = Zomb_Pool[i].instantiate()
		Zomb_Values.append(zombie_instance.Worth)
		Zomb_Pick_Preference.append(zombie_instance.Preference)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func Calculate_spawn_weight(Chances):
	#Calculate weights
	#print("Chances = ",Chances)
	var weights = []
	for Chance in Chances.size():
		weights.append(1.0/(Chances[Chance] + 1))
	
	#print("Weights = ",weights)
	
	#normalize the weights
	var total_weight = Sum_Array(weights)
	#print("total weight = ",total_weight)
	var probabilities = []
	for weight in weights:
		probabilities.append(float(weight)/float(total_weight))
	#	print("Weight = ", weight)
	#	print("total_Weight = ",total_weight)
	#	print("Weight/Total_Weight = ", float(weight)/float(total_weight))
	#print("total probabilities = ",probabilities)
	#create cumulative ranges
	var cumulative_ranges = []
	var cumulative_sum = 0
	for probability in probabilities:
		cumulative_sum += probability
		cumulative_ranges.append(cumulative_sum)
	
	return cumulative_ranges

func Sum_Array(Some_Array):
	var total = 0
	for i in Some_Array.size():
		total += Some_Array[i]
	return total

func pick(cumulative_ranges):
	var random_num = randf()
	
	for i in range(cumulative_ranges.size()):
		if random_num <= cumulative_ranges[i]:
			#print("i = ",i)
			return i

func pickable_zombies(worth):
	var pickable = []
	for i in Zomb_Values.size():
		if Zomb_Values[i] <= worth:
			pickable.append(Zomb_Pick_Preference[i])
	#print("pickable = ", pickable)
	return pickable

func Spawn_Wave(Worth:int,Total_Sun_In_Lane:Dictionary):
	#var Zomb_Value
	var worth = Worth
	var Zombie_Spawn_Chances = Calculate_spawn_weight(Total_Sun_In_Lane)
	
	#print("Spawn_Chances = ",Zombie_Spawn_Chances)
	#print("worth = ", worth)
	while worth > 0: # Start at Worth, stop before -1, step down by -Zomb_Value
		var random_time = float(randf()/5)
		var zomb_type = Calculate_spawn_weight(pickable_zombies(Worth))
		#print("random time = ",random_time)
		Spawn_Zombie(pick(Zombie_Spawn_Chances),pick(zomb_type))
		#print("spawning lanes = ",Zombie_Spawns.size())
		await get_tree().create_timer(random_time).timeout
		
		worth -= Zomb_Value
		#print("-zomb = ",worth)
	
	FiftyFiftyRule = wave_health/2

func Spawn_Zombie(Lane,Type) -> void:
	#var random_num = randi() % (Zombie_Spawns.size())
	#print("picked lane = ",Lane)
	#print("zombie_spawns = ",Zombie_Spawns)
	#print("centre = ",Vector3(Zombie_Spawns[Lane]))
	var Spawn_Tile_Center = Vector3(Zombie_Spawns[Lane])
	var zombie_instance = Zomb_Pool[Type].instantiate()
	#Zombie_Rows_Tracker[Lane].append(zombie_instance)
	zombie_instance.position = Spawn_Tile_Center + Vector3(0,1,-1)
	Zomb_Value = Zomb_Values[Type] # get the worth
	#wave_health += zombie_instance.health
	if !Zombies_Spawned.has(Lane):
		Zombies_Spawned[Lane] = []
	Zombies_Spawned[Lane].append(zombie_instance)
	#print("Wave Zombies = ",Zombies_Spawned)
	add_child(zombie_instance)

func kill():
	if Zombies_Spawned.size() == 1:
		print("wave killed")
		self.queue_free()

func Add_Health(Health):
	wave_health += Health

func Minus_Health(Health):
	wave_health -= Health
	print("wave health = ", wave_health)
	if wave_health < FiftyFiftyRule:
		print("50/50 just skipped the wave!!!")
		get_parent().skip_timer_action()
