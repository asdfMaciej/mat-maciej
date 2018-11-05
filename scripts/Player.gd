extends RigidBody2D
const SPEED = 200
var movedir = Vector2(0, 0)
# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
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
	#move_and_slide(motion, Vector2(0,0))
	apply_impulse(Vector2(0,0),motion)
	#move_and_collide(motion)
	
func _physics_process(delta):
	controls_loop()
	movement_loop(delta)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
