extends Area2D


@export var double_get_parent = false

func _on_area_entered(area):
	if area.name == "PlayerHurtbox":
		if !double_get_parent:
			get_parent().no_timer = true
			get_parent().boss = false
		else:
			get_parent().get_parent().no_timer = true
			get_parent().get_parent().boss = false
