extends Node3D
class_name Hitbox_Component

@export var health_component : Health_Component

# Called when the node enters the scene tree for the first time.
func damage(attack) -> void:
	#print("hitbox got message")
	if health_component:
		health_component.damage(attack)
