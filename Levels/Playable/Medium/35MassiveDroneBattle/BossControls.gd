extends Node2D


var active = false
var controlling_ship = false
var velocity = Vector2.ZERO

@onready var loaded_missile = preload("res://Objects/StaticObjects/Exploder.tscn")

func get_horizontal_direction_pressed():
	return Input.get_axis("left", "right")
	
func get_vertical_direction_pressed():
	return Input.get_axis("jump", "down")

func _process(delta):
	if !active:
		$ShipMovementControlEIconActivator/CollisionShape2D.disabled = true
		$ShipControlsEIcon.visible = false
		$MissileFireEIcon.visible = false
	
	if active:
		$ShipMovementControlEIconActivator/CollisionShape2D.disabled = false
		
		if $ShipControlsEIcon.visible && !controlling_ship && Input.is_action_just_pressed("interact"):
			get_parent().get_node("Player").get_node("Player").disable_controlls = true
			controlling_ship = true
			
		elif $ShipControlsEIcon.visible && controlling_ship && Input.is_action_just_pressed("interact"):
			get_parent().get_node("Player").get_node("Player").disable_controlls = false
			controlling_ship = false
		
		if $MissileFireEIcon.visible && $MissileFireCooldown.time_left <= 0 && Input.is_action_just_pressed("interact"):
			$MissileFireCooldown.start()
			var missile_object = loaded_missile.instantiate()
			missile_object.velocity.x = 15
			missile_object.position = position + $MissileFirePosition.position
			get_parent().add_child(missile_object)
			
		if controlling_ship:
			velocity.x += get_horizontal_direction_pressed() * 0.02
			if get_vertical_direction_pressed() == 0:
				velocity.y -= abs(get_horizontal_direction_pressed()) * 0.02 if velocity.y > 0 else -abs(get_horizontal_direction_pressed()) * 0.02
			
			velocity.y += get_vertical_direction_pressed() * 0.02
			if get_horizontal_direction_pressed() == 0:
				velocity.x -= abs(get_vertical_direction_pressed()) * 0.02 if velocity.x > 0 else -abs(get_vertical_direction_pressed()) * 0.02
			
		if abs(velocity.x) > 3:
			velocity.x = 3 if velocity.x > 0 else -3
		if abs(velocity.y) > 3:
			velocity.y = 3 if velocity.y > 0 else -3
			
		position += velocity * delta * 60

func _on_ship_movement_control_e_icon_activator_area_entered(area):
	if area.name == "PlayerHurtbox" && active:
		$ShipControlsEIcon.visible = true

func _on_ship_movement_control_e_icon_activator_area_exited(area):
	if area.name == "PlayerHurtbox" && active:
		$ShipControlsEIcon.visible = false

func _on_ship_missile_fire_e_icon_enabler_area_entered(area):
	if area.name == "PlayerHurtbox" && active:
		$MissileFireEIcon.visible = true

func _on_ship_missile_fire_e_icon_enabler_area_exited(area):
	if area.name == "PlayerHurtbox" && active:
		$MissileFireEIcon.visible = false

func _on_ship_controls_activator_area_area_entered(area):
	if area.name == "PlayerHurtbox":
		active = true
