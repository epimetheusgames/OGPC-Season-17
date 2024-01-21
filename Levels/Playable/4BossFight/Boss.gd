extends CharacterBody2D


@onready var graphics_efficiency = get_parent().graphics_efficiency
@onready var player = get_parent().get_node("Player").get_node("Player")
@onready var loaded_bullet = preload("res://Objects/StaticObjects/DroneBullet.tscn")
@onready var loaded_mele = preload("res://Objects/StaticObjects/AttackMele.tscn")
@onready var loaded_drill = preload("res://Objects/StaticObjects/Drill.tscn")

@export var health = 100

var dropped_enemies = false

func shoot_bullet(pos):
	var direction_to_player = (player.position - position + player.get_parent().position - pos).normalized()
	var bullet_to_add = loaded_bullet.instantiate()
	bullet_to_add.position = position + pos
	bullet_to_add.velocity = direction_to_player * 3
	bullet_to_add.graphics_efficiency = graphics_efficiency
	get_parent().add_child(bullet_to_add)
	
func spawn_mele(pos):
	var mele_to_add = loaded_mele.instantiate()
	mele_to_add.position = position + pos
	get_parent().add_child(mele_to_add)
	
func spawn_drill(pos):
	var drill_to_add = loaded_drill.instantiate()
	drill_to_add.position = position + pos
	drill_to_add.disable_hitbox_when_dead = true
	get_parent().add_child(drill_to_add)

func _on_new_bullet_timer_timeout():
	if player.position.distance_to(position) < 600 && player.current_ability == "ArmGun":
		shoot_bullet($BossShootPosition.position)
		shoot_bullet($BossShootPosition2.position)

func _on_boss_hurtbox_area_entered(area):
	if area.name == "PlayerBulletHurter":
		health -= 0.8
		player.get_parent().get_node("Camera").get_node("BossBar").value = health
		
func _process(delta):
	if !player.current_ability == "Weapon":
		dropped_enemies = false
	elif !dropped_enemies:
		dropped_enemies = true
		spawn_mele($MeleSpawn.position)
		spawn_mele($MeleSpawn2.position)
		
		if health < 50:
			spawn_drill($MeleSpawn3.position)
