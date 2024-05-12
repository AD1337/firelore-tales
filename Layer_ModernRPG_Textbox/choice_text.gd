extends RichTextLabel


#choices_shown
#var info: Dictionary
var index:int


var dialogic: DialogicGameHandler = DialogicUtil.autoload()


func set_info(_index: int, choice: String):
	index = _index
	text = choice


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			print("pressed")
			## info: {'button_index':button_index, 'text':text, 'enabled':enabled, 'event_index':event_index}
			var info:Dictionary = {
				'button_index': 0,
				'text': text,
				'enabled': true,
				'event_index': index,
			}
			#dialogic.Choices.choice_selected.emit(info)
			dialogic.Choices._on_ChoiceButton_choice_selected(6,info)
