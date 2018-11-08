extends KinematicBody2D
const SPEED = 200
const DEBUG = false
var movedir = Vector2(0, 0)
var current_areas = []; # stos
var last_area = null;

func _ready():
	pass
	

func controls_loop():
	var LEFT = Input.is_action_pressed("ui_left")
	var RIGHT = Input.is_action_pressed("ui_right")
	var UP = Input.is_action_pressed("ui_up")
	var DOWN = Input.is_action_pressed("ui_down")
	
	movedir.x = -int(LEFT) + int(RIGHT)
	movedir.y = -int(UP) + int(DOWN)

func movement_loop(delta):
	var motion = movedir.normalized() * SPEED
	move_and_slide(motion, Vector2(0,0))
	
func _physics_process(delta):
	controls_loop()
	movement_loop(delta)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func on_map_change():
	last_area = null
	current_areas = []

func _on_Area2D_body_entered(body):  # odpala sie raz na poczatku z Playerem i TileMap
    if DEBUG: print(str('Body entered: ', body.get_name()))

func _on_Area2D_area_entered(area):  # odpala sie przy wejsciu do biedry
	current_areas.append(area)
	last_area = area
	if DEBUG: print(str('Area entered: ', area.get_name()))
	if DEBUG: print(current_areas)

func _on_Area2D_area_exited(area):
	current_areas.erase(area)
	last_area = current_areas.pop_back()
	if DEBUG: print(str('Area exited: ', area.get_name()))
	if DEBUG: print(current_areas)
	if DEBUG: print(last_area)

func _on_Area2D_body_exited(body):
	pass
