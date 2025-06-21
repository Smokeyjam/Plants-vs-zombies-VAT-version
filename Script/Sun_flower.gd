class_name Sun_Flower extends Plant


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Bullet = preload("res://Prefabs/sun.tscn")
	#Cost = 50
	#Cooldown_Place = 7.5 
	#Cooldown_Shoot = 24
	
	#Idle()
	#smoke
	#if is_enbled == true:
	#	particles.emitting = true
	#	await get_tree().create_timer(1).timeout
	#	particles.emitting = false
	#else:
	#	particles.queue_free()
	
	
	#play Idle

func _physics_process(delta: float) -> void:
	Shoot()

#func Idle() -> void:
	#Gun_anim.play("Idle")
	
#func _on_animation_player_animation_finished(Idle):
	#Idle()
