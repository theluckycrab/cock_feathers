extends Spatial

onready var mount = $Mount
export(String) var start_scene = "main_menu"

func _ready():
	var _d = Events.connect("scene_change_request", self, "change_scene")
	change_scene(start_scene)

remote func change_scene(s):
	if get_tree().network_peer and get_tree().get_network_unique_id() == 1:
		rpc("change_scene", s)
	for i in mount.get_children():
		i.queue_free()
	var scene = load("res://scenes/"+s+".tscn").instance()
	mount.add_child(scene)
