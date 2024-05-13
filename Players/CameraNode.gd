extends Node3D

@onready var player : Node = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

const ANGLE_MAX : float = 80.0
const ANGLE_MIN : float = -80.0

func _input(event):
	if event is InputEventMouseMotion:
		var angle : float = rad_to_deg(get_rotation().x) + (event.relative.y * player.mouse_senc)
		if angle < ANGLE_MAX and angle > ANGLE_MIN:
			rotate_x(deg_to_rad(event.relative.y * player.mouse_senc))
