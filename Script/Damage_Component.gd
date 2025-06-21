extends Node3D
class_name Damage_Component

@export var attack_damage := 100
@export var Attack_Cooldown:float = 1
@export var Cooldown := false

@onready var Zombie_Root := $".."

#func _on_hitbox_area_entered(area):
#	print("hit somethin!!!")
#	print(area.name)
#	if area is Hitbox_Component:
#		print("found hitbox")
#		var hitbox : Hitbox_Component = area	
#		var attack = Attack.new()
#		attack.attack_damage = attack_damage
#		hitbox.damage(attack)# Replace with function body.
#		Max_Hits -= 1
#		if Max_Hits <= 0:
#			queue_free()

#func _on_area():

func _on_area_entered(area):
	#print("hit somethin!!!")
	#print(area.name)
	if area is Hitbox_Component:
		#print("found hitbox")
		var hitbox : Hitbox_Component = area
		var attack = Attack.new()
		attack.attack_damage = attack_damage
		
		while area.health_component.health > 0 and is_instance_valid(area.health_component):
			Zombie_Root.Attackin(true)
			await get_tree().create_timer(Attack_Cooldown).timeout
			if !is_instance_valid(area):
				break
			hitbox.damage(attack)
	
	Zombie_Root.Attackin(false)
