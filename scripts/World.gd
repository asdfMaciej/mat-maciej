extends Node2D

var player
var map
var hud
var root

func _ready():
	root = get_node(".")
	player = get_node("Player")
	map = get_node("Map")
	hud = get_node("HUDLayer/HUD")
	change_map("res://maps/workplace.tscn")

func on_map_change():
	var start_position = map.map_information["start_position"]
	player.position = start_position
	player.on_map_change()

func change_map(path="res://maps/outside.tscn"):
	root.remove_child(map)
	map.call_deferred("free")
	
	var new_map = load(path).instance()
	root.add_child_below_node(get_node("HUDLayer"), new_map)
	map = new_map

	on_map_change()