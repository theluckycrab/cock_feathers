extends Controllable
class_name Player

func _ready():
	var _d = Events.connect("round_start", self, "set_active", [true])

func _physics_process(_delta):
	_controls()
	move()


func _controls():
	controls()
	if active and net_owner == get_tree().get_network_unique_id():
		if Input.is_action_just_pressed("left_click"):
			rpc("shoot_arrow")
		
remotesync func shoot_arrow():
	set_active(false)
	var a = load("res://controllable/arrow.tscn").instance()
	get_parent().add_child(a)
	a.connect("hit", self, "set_active", [true])
	var offset = Vector3(0, 0, -3).rotated(Vector3.UP, body.rotation.y)
	a.global_transform.origin = global_transform.origin + offset
	a.body.rotation.y = body.rotation.y
	a.net_owner = net_owner
	a.set_active(true)
	pass


