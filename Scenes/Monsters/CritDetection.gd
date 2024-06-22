extends Area3D

func take_damage(damage : int):
	get_parent().get_parent().take_damage(damage)
