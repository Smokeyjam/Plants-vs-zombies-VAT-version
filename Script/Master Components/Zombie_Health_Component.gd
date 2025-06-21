class_name Zombie_Health_Component extends Health_Component

@export var EXTRA_HEALTH:float = 89 #this is a zombie thing, when it dies
@export var ARMOUR:float = 0
@export var Damage_Hitbox : Area3D
@onready var Zombie_Root = $".."
var Hitbox_Timer := true
var extra_health:float
var armour:int
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	health = MAX_HEALTH # Replace with function body.
	armour = ARMOUR
	extra_health = EXTRA_HEALTH
	
	var total_health = health + armour
	get_parent().get_parent().Add_Health(total_health)#Wave parent

# Called every frame. 'delta' is the elapsed time since the previous frame.
func damage(attack: Attack) -> void:
	
	#if attack.lawn_mower == true:
	#get_parent().queue_free()
	
	get_parent().get_parent().Minus_Health(attack.attack_damage)
	
	if armour >= 0:
		armour -= attack.attack_damage
		#print("hit armour")
		return
	
	health -= attack.attack_damage
	
	if health <= 0 and extra_health > 0:
		if Hitbox_Timer == true:
			Hitbox_Timer = false
			Damage_Hitbox.queue_free()
			particles.emitting = true
			#Zombie_Root.Seconds_Per_Grid = Zombie_Root.Seconds_Per_Grid * 2
			#Zombie_Root.Dead = true
			Zombie_Root.Died()
			#Death_Timer(Time_After_Death)
			#Posion_Damage()
		else:
			#print("took damage")
			extra_health -= float(attack.attack_damage)
		
		if extra_health <= 0:
			#print("dead")
			particles.emitting = true
			if is_instance_valid(Hitbox):
				Hitbox.queue_free()
			Zombie_Root.Died_animation()
			await get_tree().create_timer(2).timeout
			get_parent().get_parent().kill()
			get_parent().queue_free()
