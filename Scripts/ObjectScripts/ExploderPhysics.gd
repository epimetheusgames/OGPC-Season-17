# -------------------------------------------------------------------------------------------------------|
# Copyright (C) 2024 Carson Bates, Liam Siegal, Elouan Grimm, Alejandro Belgique, and Ranier Szatlocky.  |
# All rights reserved.                                                                                   |
#                                                                                                        |
# Email us at <epimtheusgamesogpc@gmail.com>                                                             |
# -------------------------------------------------------------------------------------------------------|


extends Node2D


var velocity = Vector2.ZERO
var exploded = false
@export var no_damage = false
@export var gravity = true
@onready var player = get_parent().get_node("Player").get_node("Player")

func _ready():
	$ExplosionHitbox/CollisionShape2D.shape = $ExplosionHitbox/CollisionShape2D.shape.duplicate()

func _on_explosion_hitbox_body_entered(body):
	if !exploded:
		player = get_parent().get_node("Player").get_node("Player")
		
		exploded = true
		$GPUParticles2D.emitting = true
		$ExplosionHitbox/CollisionShape2D.shape.radius = 32
		$Timer.start()
		$Timer2.start()
		$Sprite2D.visible = false
	
		if player.position.distance_to(position) < 30:
			var direction_to_player = (player.position - position).normalized()
			player.velocity = direction_to_player * 5
			
		if player.position.distance_to(position) < 150:
			player.get_parent().screenshake_enabled = true
		
func _process(delta):
	if !exploded:
		if gravity:
			velocity.y += 0.2
			
		position += velocity * delta * 60

func _on_timer_timeout():
	queue_free()

func _on_timer_2_timeout():
	$ExplosionHitbox.queue_free()
