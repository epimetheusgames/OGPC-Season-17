# -------------------------------------------------------------------------------------------------------|
# Copyright (C) 2024 Carson Bates, Liam Siegel, Elouan Grimm, Alejandro Belgique, and Ranier Szatlocky.  |
# All rights reserved.                                                                                   |
#                                                                                                        |
# Email us at <epimtheusgamesogpc@gmail.com>                                                             |
# -------------------------------------------------------------------------------------------------------|

extends Node2D


var locked = false

func _on_area_2d_area_entered(area):
	if area.name == "PlayerHurtbox" && !locked:
		$PropDoorSideways.visible = !$PropDoorSideways.visible
		$PropDoorFaceForward.visible = !$PropDoorFaceForward.visible

func _on_area_2d_area_exited(area):
	if area.name == "PlayerHurtbox" && !locked:
		$PropDoorSideways.visible = !$PropDoorSideways.visible
		$PropDoorFaceForward.visible = !$PropDoorFaceForward.visible
