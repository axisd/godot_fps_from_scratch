extends CharacterBody3D

@export var mouse_senc : float = -0.10

@onready var health : int = 100

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var weapons_array : Array[Array] = [
	["popgun" , preload("res://Scenes/Weapons/PopGun/pop_gun.tscn"), load("res://Scenes/Weapons/PopGun/Pic/popgun.png")]		# 0
	, ["shotgun" , preload("res://Scenes/Weapons/Shotgun/shotgun.tscn"), load("res://Scenes/Weapons/Shotgun/Pic/shotgun_ico.png")]	# 1
	]

@onready var current_weapon_index : int = 0
		
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$CameraNode/GunNode.add_child(weapons_array[current_weapon_index][1].instantiate())
	$CameraNode/Camera/UI/CurrentWeapon.texture = weapons_array[current_weapon_index][2]
	
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(event.relative.x * mouse_senc))
		
	if event.is_action_pressed("esc"):
		get_tree().quit()
		
	if event.is_action_pressed("change_weapon_down"):
		var check_w_index : int = current_weapon_index
		if current_weapon_index == weapons_array.size() - 1:
			current_weapon_index = 0			
		else:
			current_weapon_index += 1
		
		if check_w_index != current_weapon_index:
			var current_weapon_node := $CameraNode/GunNode.get_child(0)
			$CameraNode/GunNode.remove_child(current_weapon_node)
			$CameraNode/GunNode.add_child(weapons_array[current_weapon_index][1].instantiate())
			$CameraNode/Camera/UI/CurrentWeapon.texture = weapons_array[current_weapon_index][2]
		
		print("weapon: ", weapons_array[current_weapon_index][0])
		
		
	if event.is_action_pressed("change_weapon_up"):
		var check_w_index : int = current_weapon_index
		if current_weapon_index == 0:
			current_weapon_index = weapons_array.size() - 1
		else:
			current_weapon_index -= 1
			
		if check_w_index != current_weapon_index:
			var current_weapon_node := $CameraNode/GunNode.get_child(0)
			$CameraNode/GunNode.remove_child(current_weapon_node)
			$CameraNode/GunNode.add_child(weapons_array[current_weapon_index][1].instantiate())
			$CameraNode/Camera/UI/CurrentWeapon.texture = weapons_array[current_weapon_index][2]
			
		print("weapon: ", weapons_array[current_weapon_index][0])

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("a", "d", "w", "s")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func take_damage(damage : int):
	health -= damage
	update_health()
	if health <= 0:
		print("we are death")

func update_health():
	$CameraNode/Camera/UI/HP.text = str(health)


func take_heal(hp : int):
	if health < 100:
		if 100 - health >= hp:
			health += hp
		else:
			health = 100
	update_health()
