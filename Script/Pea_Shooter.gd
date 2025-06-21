class_name Pea_Shooter extends Plant

#var Bullet := load("res://Prefabs/Bullets/pea_pellet.tscn")
var Kill_Wall:float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	#Cost = 100
	#Cooldown_Place = 7.5 
	#Cooldown_Shoot = 1.5
	#if is_enbled == true:
	Bullet = preload("res://Prefabs/Bullets/pea_pellet.tscn")
	Kill_Wall = Map_initiator.Kill_Wall_Z
		
	#particles.emitting = true
	#await get_tree().create_timer(1).timeout
	#particles.emitting = false
	
	
	#start Idle
	#Idle()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if In_Range():
		Shoot()
		#Gun_anim.set("request",AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		if is_instance_valid(Bullet_Instance):
			Bullet_Instance.Kill_Wall = Kill_Wall

func In_Range() -> bool:
	#Kill_Wall = %Projectile_Kill_pos
	var Barrel_pos = gun_barrel.global_position
	var from = Barrel_pos
	var to = Vector3(Barrel_pos.x,Barrel_pos.y,-Kill_Wall)
	#print("from = ",from,",to = ",to)
	var space = get_world_3d(). direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = from
	ray_query.to = to
	ray_query.collide_with_bodies = false
	ray_query.collide_with_areas = true
	ray_query.collision_mask = 2
	var raycast_result = space.intersect_ray(ray_query)

	if !raycast_result.is_empty(): #raycast_result.collider.collision_layer == 2
		#zombies are on layer 2 so peashooter won't try to shoot itself
		#print("hit")
		#print("name: ",raycast_result.collider.collision_layer)
		return true
	else:
		return false

#func Idle() -> void:
	#Gun_anim.play("Idle")

#func _on_animation_player_animation_finished(Idle):
	#Idle()
