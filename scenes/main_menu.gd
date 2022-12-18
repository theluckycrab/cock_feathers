extends VBoxContainer

onready var host_button = $HostButton
onready var join_button = $JoinPanel/JoinButton
onready var ip_entry = $JoinPanel/IPEntry
onready var start_button = $JoinPanel/StartButton
onready var player_list = $PlayerList

func _ready():
	var _d = Events.connect("player_joined", self, "on_player_joined")
	host_button.connect("button_down", self, "on_host_button")
	join_button.connect("button_down", self, "on_join_button")
	start_button.connect("button_down", self, "on_start_button")
	
func on_host_button():
	Network.host()
	hide_buttons()
	add_player_label(1)
	
func on_join_button():
	Network.join(ip_entry.text)

func on_player_joined(who):
	add_player_label(who)
	hide_buttons()
	show_start()
	pass
	
func hide_buttons():
	host_button.hide()
	join_button.hide()
	ip_entry.hide()
	
func show_start():
	if get_tree().get_network_unique_id() == 1:
		start_button.show()

func add_player_label(who):
	var l = Label.new()
	l.text = str(who)
	if who == get_tree().get_network_unique_id():
		l.text = "You : " + l.text
	l.align = Label.ALIGN_CENTER
	player_list.add_child(l)
	
func on_start_button():
	Events.emit_signal("scene_change_request", "map")
