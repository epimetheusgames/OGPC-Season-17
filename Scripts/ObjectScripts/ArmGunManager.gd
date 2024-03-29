# -------------------------------------------------------------------------------------------------------|
# Copyright (C) 2024 Carson Bates, Liam Siegal, Elouan Grimm, Alejandro Belgique, and Ranier Szatlocky.  |
# All rights reserved.                                                                                   |
#                                                                                                        |
# Email us at <epimtheusgamesogpc@gmail.com>                                                             |
# -------------------------------------------------------------------------------------------------------|


extends Node2D

@onready var loaded_bullet = preload("res://Objects/StaticObjects/PlayerBullet.tscn")
@onready var point_1_start_x = $Line2D.points[1].x

var active = false

func _process(delta):
	if active:
		visible = true
		
		var mouse_pos = get_viewport().get_mouse_position() - Vector2(get_viewport_rect().size.x / 2, get_viewport_rect().size.y / 2)
		
		if get_parent().previous_direction == -1:
			mouse_pos.x = -mouse_pos.x
		
		$Line2D.points[2].x = mouse_pos.x / 100 + (mouse_pos.y / 80) - 20
		$Line2D.points[2].y = -25 - (mouse_pos.x / 150) + (mouse_pos.y / 200)
		
		var reversed_points_2 = Vector2(-$Line2D.points[2].x, $Line2D.points[2].y)
		var mouse_direction = (get_global_mouse_position() - (get_parent().position + get_parent().get_parent().position + (Vector2(-12, -18) if get_parent().previous_direction == 1 else Vector2(8, -18)))).normalized()
		var reversed_mouse_dir = Vector2(-mouse_direction.x, mouse_direction.y)
		
		# For controller
		if len(Input.get_connected_joypads()) > 0:
			var controller_joy_dir_x
			var controller_joy_dir_y
			if len(Input.get_connected_joypads()) > 1:
				controller_joy_dir_x = Input.get_joy_axis(Input.get_connected_joypads()[1], JOY_AXIS_RIGHT_X)
				controller_joy_dir_y = Input.get_joy_axis(Input.get_connected_joypads()[1], JOY_AXIS_RIGHT_Y)
			else:
				controller_joy_dir_x = Input.get_joy_axis(Input.get_connected_joypads()[0], JOY_AXIS_RIGHT_X)
				controller_joy_dir_y = Input.get_joy_axis(Input.get_connected_joypads()[0], JOY_AXIS_RIGHT_Y)
			mouse_direction = Vector2(controller_joy_dir_x, controller_joy_dir_y)
			reversed_mouse_dir = Vector2(-mouse_direction.x, mouse_direction.y)
			mouse_pos = mouse_direction * 50
		
		$Line2D.points[3] = $Line2D.points[2] + ((mouse_direction if get_parent().previous_direction == 1 else reversed_mouse_dir) * 20)
		
		if get_parent().previous_direction == -1:
			$Line2D.points[3].x = -$Line2D.points[3].x
			$Line2D.points[2].x = -$Line2D.points[2].x
			$Line2D.points[1].x = -point_1_start_x
			
			$Segment1.rotation_degrees = 48
			$Segment1.position.x = 10
			$Segment2.rotation_degrees = -27.4
			$Segment2.position.x = 12
			$Segment3.position = (Vector2(8, -18) + mouse_direction * 8)
			$Hinge1.position.x = 15
			$Hinge2.position.x = 7
			$Segment3.flip_h = false
		else:
			$Line2D.points[1].x = point_1_start_x
			
			$Segment1.rotation_degrees = -48
			$Segment1.position.x = -14
			$Segment2.rotation_degrees = 27.4
			$Segment2.position.x = -16
			$Segment3.position = (Vector2(-12, -18) + mouse_direction * 8)
			$Hinge1.position.x = -19
			$Hinge2.position.x = -14
			$Segment3.flip_h = true
			
		$Segment3.rotation = atan2(mouse_direction.y, mouse_direction.x) - (1.0 / 2.0) * PI
			
		
		if Input.is_action_just_pressed("mouse_click") || Input.is_action_just_pressed("attack"):
			var bullet = loaded_bullet.instantiate()
			bullet.position = get_parent().position + (Vector2(8, -18) if get_parent().previous_direction == -1 else Vector2(-12, -18)) + mouse_direction * 16
			bullet.direction = mouse_direction
			bullet.velocity = 7
			bullet.graphics_efficiency = get_parent().get_parent().graphics_efficiency
			get_parent().get_parent().add_child(bullet)
	else:
		visible = false
