extends Node3D

@onready var Gun_anim := %AnimationPlayer
@onready var Bullet := load("res://Prefabs/bullet.tscn")
@onready var gun_barrel := %Barrel

var instance

#mouse input for aiming 
#func _input(event):
	#if event is InputEventMouseMotion: #and event.button_mask & 1:
		# modify accumulated mouse rotation
		#mouse_pos = get_viewport().get_mouse_position()
		#rot_x += event.relative.x * LOOKAROUND_SPEED
		#rot_y += event.relative.y * LOOKAROUND_SPEED
		#transform.basis = Basis() # reset rotation
		#rotate_object_local(Vector3(0, 1, 0), rot_x) # first rotate in Y
		#rotate_object_local(Vector3(1, 0, 0), rot_y) # then rotate in X
		#look_at(Vector3(mouse_pos.y,1,mouse_pos.x))

func _physics_process(delta: float):
	
	look_at(%Mouse_pos.position)
	
	if Input.is_action_pressed("Shoot"):
		if !Gun_anim.is_playing():
			Gun_anim.play("Shoot")
			instance = Bullet.instantiate()
			instance.position = gun_barrel.global_position
			instance.transform.basis = gun_barrel.global_transform.basis
			get_parent().get_parent().add_child(instance)
