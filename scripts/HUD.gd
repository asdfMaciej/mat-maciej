extends ViewportContainer

var player
var camera
var tween  # sluzy do zmieniania w czasie wartosci plynnie
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
	labels["place"] = get_node("Sidebar/Messages/Place")
	textures["place"]["biedronka"] = preload("res://sprites/hud/place_biedronka.png")
	textures["place"]["kiosk"] = preload("res://sprites/hud/place_kiosk.png")
	textures["place"]["town"] = preload("res://sprites/hud/place_town.png")
	
	textures["player"]["happy"].append(preload("res://sprites/hud/player_happy.png"))
	textures["player"]["happy"].append(preload("res://sprites/hud/player_happy2.png"))
	textures["player"]["happy"].append(preload("res://sprites/hud/player_licking.png"))
	textures["player"]["angry"].append(preload("res://sprites/hud/player_angry.png"))
	textures["player"]["sad"].append(preload("res://sprites/hud/player_sad.png"))
	
	hide_sidebar()

func _process(delta):
	"""
	TO-DO:
		logika HUDu powinna znalezc sie imho w playerze
		to player powinien ustawiac hud z siebie
		a ten obiekt byc odpowiedzialny jedynie za display
		bo te zaciaganie z ../../../ troche uwiera
	"""
	var name = "Town"
	if player.last_area:
		name = player.last_area.place_information["name"]
	
	set_place(name)

func set_place(name):
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
		show_sidebar()
	if randi() % 10 == 1:
		hide_sidebar()
	
	labels["place"].text = name.capitalize()

func random_player():
	var arr = textures["player"][p_emotion]
	return arr[randi() % arr.size()]

func hide_sidebar(instantly=false):
	if not sidebar["visible"]:
		return

	if instantly:
		sidebar["node"].margin_left = -350
		camera.offset = Vector2(0, 0)
	else:
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
		tween.start()

	camera.drag_margin_left = 0.15
	camera.drag_margin_top = 0.15
	camera.drag_margin_right = 0.15
	camera.drag_margin_bottom = 0.15
	sidebar["visible"] = false

func show_sidebar(instantly=false):
	if sidebar["visible"]:
		return
	
	if instantly:
		sidebar["node"].margin_left = 0
		camera.offset = Vector2(-175, 0)
	else:
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
		tween.start()

	camera.drag_margin_left = 0.1
	camera.drag_margin_top = 0.1
	camera.drag_margin_right = 0.1
	camera.drag_margin_bottom = 0.1
	sidebar["visible"] = true