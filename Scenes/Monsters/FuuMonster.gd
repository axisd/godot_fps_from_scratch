extends CharacterBody3D

@export var speed : float = 3.0

var current_state: String = "idle"
var next_state : String = "idle"
var previous_state : String

@onready var player : CharacterBody3D

func _ready():
	$MonsterBody/AnimationPlayer.play("Rest")
	player = get_tree().get_first_node_in_group("player")
	
func _physics_process(delta : float):
	if previous_state != current_state:
		$StateLabel3D.text = current_state
	previous_state = current_state
	current_state = next_state
	
	match current_state:
		"idle":
			idle()
		"chase":
			chase(delta)
		"bite":
			bite()

func idle():
	if previous_state != current_state:
		print("fuu are idle")
		$MonsterBody/AnimationPlayer.play("Rest")
		
func chase(delta : float):
	if previous_state != current_state:
		print("fuu are chasing")
	
	velocity = ($NavigationAgent3D.get_next_path_position() - position).normalized() * speed * delta
	
	if player.position.distance_to(self.position) > 1:
		$NavigationAgent3D.target_position = player.position
		move_and_collide(velocity)
		
func bite():
	if previous_state != current_state:
		print("fuu are biting")
		$MonsterBody/AnimationPlayer.play("Bite")

func take_damage(damage : int):
	print("fuu take damage: ", damage)

# slots
func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		next_state = "bite"


func _on_area_3d_body_exited(body):
	if body.is_in_group("player"):
		next_state = "idle"


func _on_aggro_area_3d_body_entered(body):
	if body.is_in_group("player"):
		next_state = "chase"


func _on_aggro_area_3d_body_exited(body):
	if body.is_in_group("player"):
		next_state = "idle"
