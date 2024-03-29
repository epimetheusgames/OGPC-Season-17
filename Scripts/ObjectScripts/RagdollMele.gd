# -------------------------------------------------------------------------------------------------------|
# Copyright (C) 2024 Carson Bates, Liam Siegal, Elouan Grimm, Alejandro Belgique, and Ranier Szatlocky.  |
# All rights reserved.                                                                                   |
#                                                                                                        |
# Email us at <epimtheusgamesogpc@gmail.com>                                                             |
# -------------------------------------------------------------------------------------------------------|


extends Node2D



func _on_despawn_timer_timeout():
	modulate = Color(1, 1, 1, 0.5)
	$Head/CollisionShape2D.queue_free()
	$Body/CollisionShape2D2.queue_free()
	$Wheel/CollisionShape2D3.queue_free()

func _on_queue_free_timer_timeout():
	queue_free()
