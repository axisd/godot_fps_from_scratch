extends Node3D

@onready var can_fire : bool = true
@onready var active_weapon : bool = true

@onready var max_rounds_in_gun : int = 3
@onready var ammo_in_gun : int = 3
@onready var ammo_in_inventory : int = 300

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if active_weapon:
		if Input.is_action_just_pressed("reload"):
			if can_fire:
				reload()
		if Input.is_action_just_pressed("fire"):
			if can_fire:
				fire()

func reload():
	can_fire = false
	var rounds_needed : int = max_rounds_in_gun - ammo_in_gun
		
	if rounds_needed == 0:
		can_fire = true
		return
		
	if ammo_in_inventory > rounds_needed:
		ammo_in_inventory -= rounds_needed
		ammo_in_gun += rounds_needed
	else:
		if ammo_in_inventory == 0:
			$MisInvSound.play()
			print("no ammo in inventory")
			can_fire = true
			return
		else:
			ammo_in_gun = ammo_in_inventory
			ammo_in_inventory = 0
			
	$AnimationPlayer.play("Reload")
	$ReloadSound.play()
	print("ammo in inventory: ", ammo_in_inventory)
	print("ammo in gun: ", ammo_in_gun)
		
func fire():
	can_fire = false
	
	if ammo_in_gun > 0:
		ammo_in_gun -= 1
		$GPUParticles3D.emitting = true
		$AnimationPlayer.play("Fire")
		$FireSound.play()
		
		print("ammo in gun: ", ammo_in_gun)
	else:
		$MisFireSound.play()
		print("no ammo in gun")
		can_fire = true
		return


func _on_animation_player_animation_finished(anim_name):
	print("anim name: ", anim_name)
	if anim_name == "Fire":
		$AnimationPlayer.play("Pump")
		$PumpSound.play()
		
	if anim_name == "Pump":
		can_fire = true
		
	if anim_name == "Reload":
		can_fire = true
