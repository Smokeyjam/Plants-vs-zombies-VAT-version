extends RayCast3D

const Seconds_Per_Grid := 0.25
var Ticks_Per_Grid := Seconds_Per_Grid*60
var Speed := 2 / Ticks_Per_Grid #Speed = distance/time
@export var attack_damage := 20 #(20 is the attack damage for pea pellet)
var Kill_Wall:float

@onready var mesh := $Pea_Mesh
@onready var ray := $"."
@onready var particles := $GPUParticles3D

var area

func _physics_process(delta: float):
	
	position += transform.basis * Vector3(0,0,-Speed)
	
	if self.position.z <= -Kill_Wall:
		queue_free()
	
	if ray.is_colliding():
		
		area = ray.get_collider()		
		ray.enabled = false
		mesh.visible = false
		particles.emitting = true
		
		#print(area.name)
		#print("parent = ", area.get_parent())
		if area is Hitbox_Component:
			#print("has hitbox")
			var hitbox : Hitbox_Component = area
			var attack = Attack.new()
			attack.attack_damage = attack_damage
			hitbox.damage(attack)
		
		await get_tree().create_timer(1).timeout
		queue_free()
