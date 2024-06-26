# -------------------------------------------------------------------------------------------------------|
# Copyright (C) 2024 Carson Bates, Liam Siegel, Elouan Grimm, Alejandro Belgique, and Ranier Szatlocky.  |
# All rights reserved.                                                                                   |
#                                                                                                        |
# Email us at <epimtheusgamesogpc@gmail.com>                                                             |
# -------------------------------------------------------------------------------------------------------|

extends Node2D


var slot = -1
var graphics_efficiency = false
var is_max_level = true
var easy_mode = false
var show_fps = false
var show_points = false
var show_timer = false
var demo_max = false
var demo_running = false
var deaths_this_level = 0
var points = 0
var time = 0
var deaths = 0
var difficulty = 1
var just_unpaused = false
var last_100_raycasts = []
var cannot_stop_special_music = false
var previous_points = 0

@export var level = 0
@export var floor = 0
@export var boss = false
@export var zoom_boss = false
@export var camera_zoom = false
@export var is_multiplayer = false
@export var intense_music = false
@export var is_cutscene = false
@export var no_timer = false
@export var lights_off = false
@export var end_level = false
@export var is_credits = false
@export var spike_exception = false
@export var dont_show_bossbar = false
@export var dont_open_level_with_fade = false
@onready var server_player = $ServerPlayer
@onready var client_player = $ClientPlayer


func _ready():
	if graphics_efficiency:
		if lights_off:
			$CanvasModulate.color = Color(0.15, 0.15, 0.15, 1)
		else:
			$CanvasModulate.color = Color(0.8, 0.8, 0.8, 1) 
	else:
		if lights_off:
			$CanvasModulate.color = Color(0.1, 0.1, 0.1, 1)
		else:
			$CanvasModulate.color = Color(0.6, 0.6, 0.6, 1)
	
	if !is_multiplayer:
		if !show_fps:
			$Player/Camera/FPSCounter.visible = false
		if !show_points:
			$Player/Camera/PointsCounter.visible = false
		if !show_timer:
			$Player/Camera/TimeCounter.visible = false
	
	# Remove spikes for easy mode, should be good enough. Silly hack to add exceptions.
	if difficulty == 0 && get_node_or_null("Spikes") && !spike_exception:
		get_node("Spikes").queue_free()
		
	# Player finished the game!
	if end_level:
		get_parent().get_parent().get_node("SaveLoadFramework").save_achievement("escape")
		
		if time < 3000: # 50 minutes
			get_parent().get_parent().get_node("SaveLoadFramework").save_achievement("finish_50_min")
		if time < 2100: # 35 minutes
			get_parent().get_parent().get_node("SaveLoadFramework").save_achievement("finish_35_min")
		if time < 1500: # 25 minutes
			get_parent().get_parent().get_node("SaveLoadFramework").save_achievement("finish_25_min")
		if deaths <= 50:
			get_parent().get_parent().get_node("SaveLoadFramework").save_achievement("finish_50_deaths")
		if deaths <= 20:
			get_parent().get_parent().get_node("SaveLoadFramework").save_achievement("finish_20_deaths")
		if deaths == 0:
			get_parent().get_parent().get_node("SaveLoadFramework").save_achievement("finish_no_deaths")
		if difficulty == 2:
			get_parent().get_parent().get_node("SaveLoadFramework").save_achievement("finish_hard")

func _process(delta):
	if is_credits:
		get_parent().get_parent().get_node("SaveLoadFramework").bulge_amm = 1.7
		get_parent().get_parent().get_node("SaveLoadFramework").static_amm = 0.0
	
	if is_multiplayer:
		if multiplayer.is_server():
			client_player.set_multiplayer_authority(multiplayer.get_peers()[0])
			server_player.set_multiplayer_authority(multiplayer.get_unique_id())
			client_player.get_node("Camera").enabled = false
			client_player.get_node("Camera").visible = false
			client_player.modulate.a = 0.3
		else:
			server_player.set_multiplayer_authority(multiplayer.get_peers()[0])
			client_player.set_multiplayer_authority(multiplayer.get_unique_id())
			server_player.get_node("Camera").enabled = false
			server_player.get_node("Camera").visible = false
			server_player.modulate.a = 0.3
			
	if !end_level:
		time += delta
	
	if boss || camera_zoom:
		get_node("Player").target_zoom = Vector2(2.5, 2.5)
		
	if zoom_boss:
		get_node("Player").target_zoom = Vector2(2, 2)
		
	if end_level:
		$Label2.text = "Points: " + str(points * 10) 
	
		var hours = int(time / 60 / 60)
		var minutes = int((time - hours * 60 * 60) / 60)
		var seconds = int(time - (hours * 60 * 60) - (minutes * 60))
		var extra = time - (hours * 60 * 60) - (minutes * 60) - (seconds)
		
		$Label3.text = "Time: " + (("0" if hours < 10 else "") + ("0" if hours < 100 else "") + str(hours) + ":" if hours > 0 else "") + ("0" if minutes < 10 else "") + str(minutes) + ":" + ("0" if seconds < 10 else "") + str(seconds) + "." + str($Player.round_place(extra, 2)).lstrip("0.")
		$Label4.text = "Deaths: " + str(deaths)
	
	if is_credits:
		if $Credits/Credits.finished:
			get_tree().get_root().get_node("Root").get_node("SaveLoadFramework").exit_to_menu(level, floor, slot, points, time, is_max_level, deaths, false, difficulty)
	
	if previous_points != points:
		var saved_total = get_parent().get_parent().get_node("SaveLoadFramework").load_achievement_tracking("total_points")
		var total_points = saved_total - previous_points + points
		get_parent().get_parent().get_node("SaveLoadFramework").save_achievement_tracking("total_points", total_points)
		
		# Check if we've passed the threshold for achievements.
		if total_points >= 500 && previous_points < 500:
			get_parent().get_parent().get_node("SaveLoadFramework").save_achievement("5k_points")
		if total_points >= 1000 && previous_points < 1000:
			get_parent().get_parent().get_node("SaveLoadFramework").save_achievement("10k_points")
	
	previous_points = points

func _on_ambiant_background_finished():
	$AmbiantBackground.play()

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "ExtractLargeDrone" || anim_name == "BetterRocketLanding":
		$NextLevel.add_level()
