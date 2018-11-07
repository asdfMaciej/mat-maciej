extends ViewportContainer

var player
var label

func _ready():
	player = get_node("../../../World/Player")
	label = get_node("HBoxContainer/Label")
	#player.queue_free()
	pass

func _process(delta):
	if player.last_area:
		label.text = player.last_area.name;
	pass
