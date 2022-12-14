extends Spatial

var start_delay = 3
onready var start_timer = $Timer

func _ready():
	start_timer.connect("timeout", self, "on_start_timer")
	start_timer.start(start_delay)
	var _d = Events.connect("player_hit", self, "on_player_hit")
	
func _physics_process(_delta):
	if round(start_timer.time_left) == 0:
		$Label.text = "START!"
		return
	$Label.text = round(start_timer.time_left) as String
	
	
func on_start_timer():
	$Label.hide()
	Events.emit_signal("round_start")

func on_player_hit(_p):
	reset()
	
func reset():
	pass
