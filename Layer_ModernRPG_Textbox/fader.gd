extends Node

@onready var parent:Control = get_parent()

var is_fading_out:bool = false
var is_fading_in:bool = false

func _ready() -> void:
	#Dialogic.timeline_ended.connect(on_timeline_ended)
	#Dialogic.signal_event.connect(_on_dialogic_signal)
	Dialogic.timeline_started.connect(on_timeline_started)
	Dialogic.timeline_ended.connect(on_timeline_ended)

#func _on_dialogic_signal(argument:String):
	#if argument == "end":
		#is_fading_out = true

func on_timeline_ended():
	%Music.stop()
	is_fading_out = true

func on_timeline_started():
	%Music.play()
	parent.clear()
	parent.modulate.a = 0
	#parent.visible = true
	is_fading_in = true
	Global.set_dialog_visibility(true)


func _process(delta: float) -> void:
	if is_fading_out:
		if parent.modulate.a > 0:
			parent.modulate.a -= 0.005
		else:
			is_fading_out = false
			Signals.textbox_done_fading_out.emit()
			#parent.visible = false
			Global.set_dialog_visibility(false)
	
	elif is_fading_in:
		if parent.modulate.a < 1:
			parent.modulate.a += 0.01
		else:
			is_fading_in = false
