extends KinematicBody2D
const SPEED = 200
var movedir = Vector2(0, 0)

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

func _on_Area2D_body_entered(body):  # odpala sie raz na poczatku z Playerem i TileMap
    print(str('Body entered: ', body.get_name()))

func _on_Area2D_area_entered(area):  # odpala sie przy wejsciu do biedry
    print(str('Area entered: ', area.get_name()))

func _on_Area2D_area_exited(area):
	 print(str('Area exited: ', area.get_name()))

func _on_Area2D_body_exited(body):
	pass # replace with function body
