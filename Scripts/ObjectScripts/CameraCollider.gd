# -------------------------------------------------------------------------------------------------------|
# Copyright (C) 2024 Carson Bates, Liam Siegel, Elouan Grimm, Alejandro Belgique, and Ranier Szatlocky.  |
# All rights reserved.                                                                                   |
#                                                                                                        |
# Email us at <epimtheusgamesogpc@gmail.com>                                                             |
# ----------------------------------------CameraCollider.gd----------------------------------------------|
# Handle camera collisions.                                                                              |      
# -------------------------------------------------------------------------------------------------------|


extends CharacterBody2D

func _physics_process(delta):
	move_and_collide(velocity)
