extends Control
class_name UI 

enum Plant_Slot {
	NUM1,
	NUM2,
	NUM3,
	NUM4,
	}
@export var Selected_Slot:Plant_Slot 
@export var Chosen_Plants:Dictionary

@onready var Sun_Script = preload("res://Script/sun.gd")
@export var Sun_Text:Label

#@onready var Mesh_Manager := %Mesh_Instances_Manager
# Called when the node enters the scene tree for the first time.
func _ready():
	Update_Sun()
	#Chosen_Plants = {
	#Plant_Slot.NUM1: preload("res://Prefabs/Plants/Pea_Shooter/pea_shooter.tscn"),
	#Plant_Slot.NUM2: preload("res://Prefabs/Plants/Sun_Flower/sun_flower.tscn")
	#}
	
	#Mesh_Manager.Plant_Slot = Chosen_Plants
	#Mesh_Manager.Print_Plants()

func Plant_Selected(Plant_Prefab):
	pass

func Update_Sun() -> void:
	Sun_Text.text = "SUN: " + str(Sun_Script.Total_Sun)
# Called every frame. 'delta' is the elapsed time since the previous frame.
