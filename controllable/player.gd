extends Controllable

var active = false

func _ready():
	var _d = Events.connect("round_start", self, "set_active", [true])

func _physics_process(_delta):
	if active:
		_controls()
		move()


func _controls():
	controls()
	if Input.is_action_just_pressed("left_click"):
		shoot_arrow()
		
func shoot_arrow():
	pass

func set_active(a):
	active = a
