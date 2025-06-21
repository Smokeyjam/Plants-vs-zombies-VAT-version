class_name Map extends Game_Manager

##List of game tiles e.g grass,stone,zombie spawn
enum Tile_Type {GRASS,STONE,ROAD,FENCE,ZOMBIE,FAKE}

@export var Tile_List:Dictionary = {
Tile_Type.GRASS: [preload("res://Prefabs/Tiles/Grass_Tiles/Grass_tile_1/grass_tile.tscn"),
preload("res://Prefabs/Tiles/Grass_Tiles/Grass_tile_2/grass_tile_2.tscn"),
preload("res://Prefabs/Tiles/Grass_Tiles/Grass_tile_3/grass_tile_3.tscn"),
preload("res://Prefabs/Tiles/Grass_Tiles/Grass_tile_4/grass_tile_4.tscn")],

Tile_Type.STONE: [preload("res://Prefabs/Tiles/Stone_Tiles/Prefabs/stone_tile.tscn"),
preload("res://Prefabs/Tiles/Stone_Tiles/Prefabs/stone_tile_2.tscn"),
preload("res://Prefabs/Tiles/Stone_Tiles/Prefabs/stone_tile_3.tscn"),
preload("res://Prefabs/Tiles/Stone_Tiles/Prefabs/stone_tile_4.tscn")],

Tile_Type.ROAD: preload("res://Prefabs/Tiles/road_tile.tscn"),
Tile_Type.FENCE: preload("res://Prefabs/Tiles/Fence_Tile/fence_tile.tscn"),
}

var mat1 = preload("res://Assets/Materials/Grass_dark.tres")
var mat2 = preload("res://Assets/Materials/Grass.tres")

static var Playable_Rows:int = 5 #5
static var Playable_Columns:int = 9 #9

#var Sun_Cost_Lane:Dictionary

static var Kill_Wall_Z:float = 0
var Road_Columns:int = 3 

static var Number_Of_Tiles := Playable_Rows * Playable_Columns
#= {0: {"X_Cord": 0,"Y_Cord": 0,"Type": "Grass"}}
#key = ID of Tile and Values = (Rows = Y and Columns = X)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	Kill_Wall_Z += (Playable_Columns * 2) + 1.5
	
	Create_Map()
	Get_Spawns(Zombie_Spawns,Tile_Type.ZOMBIE)
	Get_Center(Zombie_Spawns,Zombie_Spawns_Centers)
	#Make_Zombie_Row_Tracker()
	Get_Spawns(Sun_Spawns,Tile_Type.GRASS)
	#Get_Game_State()
	#Get_Empty_Spaces()
	Move_Cam()

func Create_Map() -> void:
	Create_Playable_Area()
	#print("sun_cost = ", Sun_Cost_Lane)
	Create_Pavement()
	Create_Road()
	Create_Zombie_Side()
	#emit_signal("Map_Done")

func Create_Zombie_Side() -> void:
	#Path
	var X_Offset = Playable_Columns + 1 + Road_Columns
	var Y_Offset = -1
	#top
	#Create_Tile_Entry(1 + X_Offset + 1,3 + Y_Offset,Stone_Tile_Object,Stone_Tile)
	#Spawnable area
	var random_num
	for Y in range(Playable_Rows + 2):
		random_num = randi() % (Tile_List[Tile_Type.STONE].size())
		Create_Tile_Entry(X_Offset,Y+Y_Offset,Tile_List[Tile_Type.STONE][random_num],Tile_Type.STONE)
	#Stone_Tile_Bottom
	#Y_Offset = Playable_Rows - 1
	#Create_Tile_Entry(1 + X_Offset + 1,1 + Y_Offset,Stone_Tile_Object,Stone_Tile)
	
	#Grass (Top)
	X_Offset = Playable_Columns + 2 + Road_Columns
	Y_Offset = -1
	for X in range(3):
		Create_Tile_Entry(X + X_Offset,Y_Offset,Tile_List[Tile_Type.GRASS][Chose_Grass_Tile(X,1)],Tile_Type.FAKE)
	#Grass (Center)
	for Y in range(Playable_Rows):
		for X in range(3):
			Create_Tile_Entry(X + X_Offset,Y,Tile_List[Tile_Type.GRASS][Chose_Grass_Tile(X,Y)],Tile_Type.FAKE)
	#Grass (top and bottom of the previous area)
	Y_Offset = Playable_Rows
	for X in range(3):
		Create_Tile_Entry(X + X_Offset,Y_Offset,Tile_List[Tile_Type.GRASS][Chose_Grass_Tile(X,1)],Tile_Type.FAKE)

func Create_Pavement() -> void:
	#Create_Top_Bottom_Pavement()
	Create_Fence()
	Create_Bottom_Pavement()
	Create_Left_Right_Pavement()

func Create_Fence() -> void:
	var X_Offset = -1
	for X in range(Playable_Columns+1):
		Create_Tile_Entry(X + X_Offset,-1,Tile_List[Tile_Type.FENCE],Tile_Type.FENCE)

func Create_Bottom_Pavement() -> void:
	var X_Offset = -1
	var Y_Offset = Playable_Rows - 1
	var random_num = randi() % (Tile_List[Tile_Type.STONE].size()) 	
	for X in range(Playable_Columns + 2):
		random_num = randi() % (Tile_List[Tile_Type.STONE].size()) 	
		#print("Stone_Tile list = ",Tile_List[Tile_Type.STONE])
		#print("Stone_Tile = ",Tile_List[Tile_Type.STONE][random_num])
		Create_Tile_Entry(X + X_Offset,1 + Y_Offset,Tile_List[Tile_Type.STONE][random_num],Tile_Type.STONE)

func Create_Left_Right_Pavement() -> void:
	var X = -1
	var random_num = randi() % (Tile_List[Tile_Type.STONE].size()) 
	#Left Side
	for Y in range(Playable_Rows):
		random_num = randi() % (Tile_List[Tile_Type.STONE].size()) 
		Create_Tile_Entry(X,Y,Tile_List[Tile_Type.STONE][random_num],Tile_Type.STONE)
	X = Playable_Columns
	#Right Side
	random_num = randi() % (Tile_List[Tile_Type.STONE].size()) 
	Create_Tile_Entry(X,-1,Tile_List[Tile_Type.STONE][random_num],Tile_Type.STONE)
	for Y in range(Playable_Rows):
		random_num = randi() % (Tile_List[Tile_Type.STONE].size()) 
		Create_Tile_Entry(X,Y,Tile_List[Tile_Type.STONE][random_num],Tile_Type.ZOMBIE)

func Create_Road() -> void:
	var X_Offset = Playable_Columns + 1
	var Y_Offset = -1
	for Y in range(Playable_Rows+2):
		for X in range(Road_Columns):
			Create_Tile_Entry(X + X_Offset,Y + Y_Offset,Tile_List[Tile_Type.ROAD],Tile_Type.ROAD)
		#Y_Offset = Playable_Rows + 1 

func Create_Playable_Area() -> void:
	for Y in range(Playable_Rows):
		for X in range(Playable_Columns):
			Create_Tile_Entry(X,Y,Tile_List[Tile_Type.GRASS][Chose_Grass_Tile(X,Y)],Tile_Type.GRASS)

func Chose_Grass_Tile(X,Y) -> int:
	if !(Y + 1)% 2 == 0:
		if !(X + 1)% 2 == 0:
			return 0;
		else:
			return 1;
	else:
		if !(X + 1) % 2 == 0:
			return 2;
		else:
			return 3;

func Create_Tile_Entry(X,Y,Tile_Prefab,Type) -> void:
	
	var Tile_Instance = Tile_Prefab.instantiate()
	#print(Type)
	#print("tile grid size = ", Tile_Grid.size() + 1)
	Tile_Instance.ID = Tile_Grid.size() + 1
	Tile_Instance.X_Cord = X + 1
	Tile_Instance.Y_Cord = Y + 1
	Tile_Instance.Type = Type
	Tile_Instance.Filled = false
	Tile_Instance.Create_Tile()
	add_child(Tile_Instance)
	Tile_Grid[Tile_Grid.size()+1] = Tile_Instance
	
	#if Type == Tile_Type.GRASS or Type == Tile_Type.ZOMBIE or Type == Tile_Type.FAKE:
		#Colour_Grass_Tile(Tile_Instance)
	
	if Type == Tile_Type.GRASS and !Lanes.has(Y):
		Lanes[Y] = []
		#print("made space")
	
	if Type == Tile_Type.GRASS:
		Lanes[Y].append(Tile_Instance)

func Colour_Grass_Tile(Tile) -> void:
	var mesh = Tile.get_child(0)
	if Tile.ID % 2 == 0:
		mesh.set_surface_override_material(0,mat1)
	else:
		mesh.set_surface_override_material(0,mat2)

func Move_Cam() -> void:
	var new_follow_this = Tile_Grid[(Number_Of_Tiles+1)/2]
	var new_last_lookat = new_follow_this.global_transform.origin
	%Player.follow_this = new_follow_this
	%Player.last_lookat = new_last_lookat

func Get_Center(list,center_list):
	for i in list.size():
		center_list[i] = Vector3(list[i].Center)
	#print(center_list," real = ",Zombie_Spawns_Centers)
#func Make_Zombie_Row_Tracker() -> void:
#	for Tiles in Zombie_Spawns:
#		Zombie_Rows_Tracker[Tiles] = []
#		Spawned_in.append(Tiles)
#		print("tiles = ",Tiles, "Spawned in = ",Spawned_in)	

#old functions
func Create_Zombie_Side_old() -> void:
	#Path
	var X_Offset = Playable_Columns + 1 + Road_Columns
	var Y_Offset = -1
	for Y in range(Playable_Rows + 2):
		Create_Tile_Entry(X_Offset,Y + Y_Offset,Tile_List[Tile_Type.STONE],Tile_Type.STONE)
	#Grass (Top)
	for X in range(3):
		Create_Tile_Entry(X + X_Offset + 1,0 + Y_Offset,Tile_List[Tile_Type.GRASS],Tile_Type.FAKE)
	#Grass (where zombies can spawn)
	for Y in range(Playable_Rows):
		for X in range(3):
			Create_Tile_Entry(X + X_Offset + 1,Y,Tile_List[Tile_Type.GRASS],Tile_Type.ZOMBIE)
	#Grass (top and bottom of the previous area)
	Y_Offset = Playable_Rows - 1
	for X in range(3):
		Create_Tile_Entry(X + X_Offset + 1,1 + Y_Offset,Tile_List[Tile_Type.GRASS],Tile_Type.FAKE)

func Create_Top_Bottom_Pavement() -> void: #not used anymore
	var X_Offset = -1
	var Y_Offset = -1
	for Y in range(2):
		for X in range(Playable_Columns + 2):
			Create_Tile_Entry(X + X_Offset,Y + Y_Offset,Tile_List[Tile_Type.STONE],Tile_Type.STONE)
		Y_Offset = Playable_Rows - 1

func Create_Left_Right_Pavement_old() -> void:
	var X = -1
	#Left Side
	for Y in range(Playable_Rows):
		Create_Tile_Entry(X,Y,Tile_List[Tile_Type.STONE],Tile_Type.STONE)
	X = Playable_Columns
	#Right Side
	for Y in range(Playable_Rows+1):
		Create_Tile_Entry(X,Y-1,Tile_List[Tile_Type.STONE],Tile_Type.ZOMBIE)

#func Colour_Grid():
	#for Tile in Tile_Grid:
		#var mesh = Tile_Grid[Tile].get_child(0)
		#if Tile % 2 == 0:
		#	mesh.set_surface_override_material(0,mat1)
		#else:
		#	mesh.set_surface_override_material(0,mat2)
