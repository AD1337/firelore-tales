extends ScrollContainer


var reached_bottom: bool = false
#var can_reach_bottom: bool = false

func _ready() -> void:
	var scroll_bar: VScrollBar = get_v_scroll_bar()
	scroll_bar.scrolling.connect(stop)


func _process(delta: float) -> void:
	var text_container: VBoxContainer = %TextContainer
	var diff_y: float = text_container.size.y - size.y
	
	#if not reached_bottom and can_reach_bottom:
	if not reached_bottom:
		scroll_vertical += 1
		#if diff_y - scroll_vertical == 0:
			#reached_bottom = true


func stop():
	reached_bottom = true
	

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		event = event as InputEventMouse
		if event.button_index == MOUSE_BUTTON_WHEEL_UP or event.button_index == MOUSE_BUTTON_WHEEL_DOWN: 
			reached_bottom = true
