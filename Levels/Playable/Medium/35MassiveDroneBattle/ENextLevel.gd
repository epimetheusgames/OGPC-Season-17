extends Area2D

var player_in_area = false

func _on_area_entered(area):
	player_in_area = true

func _on_area_exited(area):
	player_in_area = false
	
func _process(delta):
	if Input.is_action_just_pressed("interact") && player_in_area:
		add_level()
		
func add_level():
	var level = get_parent().level
	var floor = get_parent().floor
	var floors_this_level = get_parent().get_parent().get_parent().get_node("SaveLoadFramework").level_node_names[level]
	var level_next = level
	var floor_next = floor
	var graphics_efficiency = get_parent().graphics_efficiency
	
	if floors_this_level[floor] == floors_this_level[-1]:
		level_next += 1
		floor_next = 0
	else:
		floor_next += 1
	
	if !get_parent().is_multiplayer:
		get_parent().get_parent().get_parent().get_node("SaveLoadFramework").switch_to_level(level_next, floor_next, level, floor, get_parent().get_node("Player").get_node("Player").character_type, get_parent().slot, graphics_efficiency, get_parent().points, get_parent().time, get_parent().deaths, get_parent().is_max_level, null, null, null, null, get_parent().easy_mode, get_parent().difficulty)
