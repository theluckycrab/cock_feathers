extends Controllable
class_name Arrow

signal hit

func _init():
	move_speed = 10
	gravity = Vector3.ZERO
	turn_speed = 0.08
	
func _ready():
	var _d = $Area.connect("body_entered", self, "on_hit")

func _physics_process(_delta):
	if active and net_owner == get_tree().get_network_unique_id():
		controls()
		velocity = Vector3(0,0,-1)
		move()

func on_hit(body):
	if body is Player:
		Events.emit_signal("player_hit", body.net_owner)
		return
	emit_signal("hit")
	queue_free()
