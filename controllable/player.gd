extends Controllable
class_name Player

var base_move_speed = move_speed

func _ready():
	var _d = Events.connect("round_start", self, "set_active", [true])

func _physics_process(delta):
	_controls()
	move(delta)


func _controls():
	controls()
	if active and net_owner == get_tree().get_network_unique_id():
		if Input.is_action_just_pressed("left_click"):
			rpc("shoot_arrow")
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.is_action_pressed("shift"):
		move_speed = base_move_speed * 1.5
		
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


