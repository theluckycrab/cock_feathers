extends Controllable
class_name Arrow

signal hit

func _init():
	move_speed = 100
	gravity = Vector3.ZERO
	turn_speed = 0.2
	
func _ready():
	var _d = $Armature/Area.connect("body_entered", self, "on_hit")

func _physics_process(delta):
	if active and net_owner == get_tree().get_network_unique_id():
		controls()
		velocity = Vector3(0,0,-1)
		move(delta)

func on_hit(body):
	if body is Player:
		Events.emit_signal("player_hit", body.net_owner)
		return
	emit_signal("hit")
	queue_free()
