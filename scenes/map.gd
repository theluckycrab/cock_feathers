extends Spatial

var start_delay = 3
onready var start_timer = $Timer

func _ready():
	start_timer.connect("timeout", self, "on_start_timer")
	var _d = Events.connect("player_hit", self, "on_player_hit")
	var p2 = get_node("Player2")
	if get_tree().get_network_unique_id() == 1:
		p2.net_owner = get_tree().get_network_connected_peers()[0]
	else:
		p2.net_owner = get_tree().get_network_unique_id()
	reset()
	
func _physics_process(_delta):
	if round(start_timer.time_left) == 0:
		return
	$Label.text = round(start_timer.time_left) as String
	
	
func on_start_timer():
	$Label.text = "START!"
	yield(get_tree().create_timer(0.5), "timeout")
	$Label.hide()
	Events.emit_signal("round_start")

func on_player_hit(p):
	$Label.text = str(p) + " WINS!"
	$Label.show()
	get_tree().paused = true
	yield(get_tree().create_timer(2), "timeout")
	reset()
	
func reset():
	get_tree().paused = false
	start_timer.start(start_delay)
	for i in get_children():
		if i is Arrow:
			i.queue_free()
	$Label.show()
	get_node("Player").global_transform.origin = $Spawn1.global_transform.origin
	get_node("Player").body.rotation.y = $Spawn1.rotation.y
	get_node("Player2").global_transform.origin = $Spawn2.global_transform.origin
	get_node("Player2").body.rotation.y = $Spawn2.rotation.y
	pass
