extends ViewportContainer

var player
var camera
var tween  # smoothly changes variables over time
var in_animation  = false # for sidebar, has to be seperate for Tweens, true if animation is in progress
var animation_stack = []
var timer
var p_emotion = "happy"
var area_name = null
var labels = {}
var sidebar = {}
var textures = {"place": {}, "player": {"happy": [], "angry": [], "sad": []}}

func _ready():
	player = get_node("../../../World/Player")
	camera = get_node("../../../World/Player/Camera2D")
	tween = get_node("../../../World/Player/Camera2D/Tween")
	
	sidebar["node"] = get_node("Sidebar")
	sidebar["place"] = get_node("Sidebar/Place")
	sidebar["player"] = get_node("Sidebar/Player")
	sidebar["visible"] = true
	labels["place_name"] = get_node("Sidebar/Messages/Place")
	labels["place_desc"] = get_node("Sidebar/Messages/PlaceDescription")
	textures["place"]["biedronka"] = preload("res://sprites/hud/place_biedronka.png")
	textures["place"]["kiosk"] = preload("res://sprites/hud/place_kiosk.png")
	textures["place"]["town"] = preload("res://sprites/hud/place_town.png")
	
	textures["player"]["happy"].append(preload("res://sprites/hud/player_happy.png"))
	textures["player"]["happy"].append(preload("res://sprites/hud/player_happy2.png"))
	textures["player"]["happy"].append(preload("res://sprites/hud/player_licking.png"))
	textures["player"]["angry"].append(preload("res://sprites/hud/player_angry.png"))
	textures["player"]["sad"].append(preload("res://sprites/hud/player_sad.png"))
	
	timer = get_node("Timer")
	timer.set_wait_time(1)
	timer.set_one_shot(false)
	timer.connect("timeout", self, "handle_animation_stack") 
	timer.start()
	hide_sidebar()

func _process(delta):
	var name = "Town"
	var desc = "Your hometown. It's older than the United States - what a surprise."
	if player.last_area:
		name = player.last_area.place_information["name"]
		desc = player.last_area.place_information["description"]
	
	set_place(name, desc)

func set_place(name, description):
	name = name.to_lower()
	if name == area_name:
		return  # my CPU cycles!!!!
	area_name = name

	if name in textures["place"]:
		sidebar["place"].set_texture(textures["place"][name])
	else:
		sidebar["place"].set_texture(textures["place"]["town"])
	
	if randi() % 10 == 0: # 1/10 chance
		sidebar["player"].set_texture(random_player())
	if randi() % 2 == 1:
		hide_sidebar()
	else:
		show_sidebar()
	
	labels["place_name"].text = name.capitalize()
	labels["place_desc"].text = description

func random_player():
	var arr = textures["player"][p_emotion]
	return arr[randi() % arr.size()]

func handle_animation_stack():  # TO-DO: move the animation handler to a seperate class
	print(animation_stack)
	if not in_animation:
		if animation_stack:
			var func_name = animation_stack.pop_front()
			funcref(self, func_name).call_func()
			return


func hide_sidebar(instantly=false):
	if not sidebar["visible"]:
		return

	if instantly:
		sidebar["node"].margin_left = -350
		camera.offset = Vector2(0, 0)
	else:
		if animation_stack.size():
			if animation_stack[-1] != "hide_sidebar_animation":
				animation_stack.append("hide_sidebar_animation")
		else:
			animation_stack.append("hide_sidebar_animation")

	camera.drag_margin_left = 0.15
	camera.drag_margin_top = 0.15
	camera.drag_margin_right = 0.15
	camera.drag_margin_bottom = 0.15
	sidebar["visible"] = false

func hide_sidebar_animation():
	tween.interpolate_property(
		sidebar["node"], "margin_left",
		0, -350, 1,
		Tween.TRANS_LINEAR, Tween.EASE_OUT
	)
	tween.interpolate_property(
		camera, "offset", 
		Vector2(-175, 0), Vector2(0, 0), 1, 
		Tween.TRANS_LINEAR, Tween.EASE_OUT
	)
	in_animation = true
	tween.interpolate_property(
		self, "in_animation", true, false, 0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT, 1
	)
	tween.start()

func show_sidebar(instantly=false):
	if sidebar["visible"]:
		return
	
	if instantly:
		sidebar["node"].margin_left = 0
		camera.offset = Vector2(-175, 0)
	else:
		if animation_stack.size():
			if animation_stack[-1] != "show_sidebar_animation":
				animation_stack.append("show_sidebar_animation")
		else:
			animation_stack.append("show_sidebar_animation")
		
func show_sidebar_animation():
	tween.interpolate_property(
		sidebar["node"], "margin_left",
		-350, 0, 1,
		Tween.TRANS_LINEAR, Tween.EASE_OUT
	)
	tween.interpolate_property(
		camera, "offset", 
		Vector2(0, 0), Vector2(-175, 0), 1, 
		Tween.TRANS_LINEAR, Tween.EASE_OUT
	)
	in_animation = true
	tween.interpolate_property(
		self, "in_animation", true, false, 0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT, 1
	)
	tween.start()

	camera.drag_margin_left = 0.1
	camera.drag_margin_top = 0.1
	camera.drag_margin_right = 0.1
	camera.drag_margin_bottom = 0.1
	sidebar["visible"] = true