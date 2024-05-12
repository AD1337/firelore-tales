@tool
class_name DialogicModernRPGTextboxLayer
extends DialogicLayoutLayer


@export var scene_display_text: PackedScene
@export var scene_choice_text: PackedScene

@export var minimum_time_until_player_can_skip_text: float = 0.5
@export var display_character_names_in_uppercase: bool = true
@export var add_quotes_to_dialogue_text: bool = true
@export var text_use_global_font: bool = true
@export var text_custom_size:int = 18
@export var text_use_global_size:bool = true

@export_file('*.ttf') var normal_font:String = ""
@export_file('*.ttf') var custom_bold_font:String = ""
@export_file('*.ttf') var custom_italic_font:String = ""
@export_file('*.ttf') var custom_bold_italic_font:String = ""

@export var display_this_string_after_character_name: String = " — "
@export var past_dialogue_text_fades_to_this_opacity: float = 0.5

@onready var text_container: VBoxContainer = %TextContainer
@onready var text_scroll_container: ScrollContainer = %TextScrollContainer
@onready var vn_choice_layer: Control = %VN_ChoiceLayer
@onready var button_continue: Button = %ButtonContinue
@onready var extra_space: MarginContainer = %ExtraSpace
@onready var continue_container: MarginContainer = %ContinueContainer
@onready var portrait: TextureRect = %Portrait


var dialogic: DialogicGameHandler = DialogicUtil.autoload()

var last_text_info: Dictionary
var last_text_object: DialogicModernRPGTextboxDisplayText

func _ready() -> void:
	Dialogic.signal_event.connect(_on_dialogic_signal)
	dialogic.Text.about_to_show_text.connect(_on_dialogic_text_event)
	dialogic.Choices.choices_shown.connect(_on_dialogic_choices_shown)
	dialogic.Choices.choice_selected.connect(_on_dialogic_choice_selected)
	#dialogic.Inputs.dialogic_action_priority.connect(_on_dialogic_action_priority)
	$Timer.wait_time = minimum_time_until_player_can_skip_text
	#button_continue.add_to_group('dialogic_next_indicator')
	clear()


func clear():
	for child in text_container.get_children():
		if child is RichTextLabel:
			child.queue_free()


func _on_dialogic_choice_selected(info:Dictionary):
	#info.character = "You"
	_on_dialogic_text_event(info)


func _on_dialogic_choices_shown(info:Dictionary):
	vn_choice_layer.move_to_front()
	text_scroll_container.ensure_control_visible(last_text_object)
	continue_container.visible = false
	extra_space.move_to_front()
	## info contains a single key called 'choices', which has an array of strings
	#var choice_indexes = dialogic.Choices.get_current_choice_indexes()
	#print(choice_indexes)
	##for choice in info.choices:
	#var choices:Array = info.choices
	#for i in choices.size():
		#var choice:String = choices[i]
		#var index:int = choice_indexes[i]
		#var choice_text = scene_choice_text.instantiate()
		#choice_text.set_info(index, choice)
		#text_container.add_child(choice_text)


func play_sound():
	var random_index:int = randi_range(0,$Audios.get_child_count()-1 )
	var audio:AudioStreamPlayer = $Audios.get_child(random_index)
	audio.pitch_scale = randf_range(0.5,1)
	audio.play()

func _on_dialogic_text_event(info:Dictionary):
	#text_scroll_container.can_reach_bottom = false
	#text_scroll_container.reached_bottom = false
	#scroll_timer.start()
	
	#print(info)
	
	if last_text_object:
		last_text_object.fade(past_dialogue_text_fades_to_this_opacity)
	text_scroll_container.ensure_control_visible(last_text_object)
	
	play_sound()
	
	## info from DialogicTextEvent:
	## 'text':final_text, 'character':character, 'portrait':portrait, 'append': is_append})
	
	# Portrait
	var set_portrait_to_blank: bool = false
	
	if info.has("character") and info.character:
		var character:DialogicCharacter = info.character
		var portrait_info: Dictionary = info.character.get_portrait_info(info.portrait)
		if not portrait_info.is_empty():
			var image_path:String = portrait_info.export_overrides.image
			image_path = image_path.trim_prefix('"')
			image_path = image_path.trim_suffix('"')
			#var image = Image.load_from_file(image_path)
			#var texture = ImageTexture.create_from_image(image)
			var portrait_texture:Texture = load(image_path)
			portrait.texture = portrait_texture
		else:
			set_portrait_to_blank = true
	else:
		set_portrait_to_blank = true
	
	if set_portrait_to_blank:
		portrait.texture = null
	
	
	# Text
	var display_text = scene_display_text.instantiate()
	display_text.set_info(info, self)
	text_container.add_child(display_text)
	last_text_object = display_text
	last_text_info = info
	$Timer.start()
	#var tween := create_tween()
	#tween.set_trans(Tween.TRANS_QUINT)
	#tween.tween_property(
		#text_scroll_container,
		#"scroll_vertical",
		#get_bottom_scroll(),
		#0.5)
	text_scroll_container.reached_bottom = false
	
	var text_size: int = text_custom_size
	if text_use_global_size:
		text_size = get_global_setting(&'font_size', text_custom_size)

	display_text.add_theme_font_size_override(&"normal_font_size", text_size)
	display_text.add_theme_font_size_override(&"bold_font_size", text_size)
	display_text.add_theme_font_size_override(&"italics_font_size", text_size)
	display_text.add_theme_font_size_override(&"bold_italics_font_size", text_size)
	
	if text_use_global_font and get_global_setting(&'font', false):
		display_text.add_theme_font_override(&"normal_font", load(get_global_setting(&'font', '') as String) as Font)
	elif !normal_font.is_empty():
		display_text.add_theme_font_override(&"normal_font", load(normal_font) as Font)

	if !normal_font.is_empty():
		display_text.add_theme_font_override(&"normal_font", load(normal_font) as Font)
	if !custom_bold_font.is_empty():
		display_text.add_theme_font_override(&"bold_font", load(custom_bold_font) as Font)
	if !custom_italic_font.is_empty():
		display_text.add_theme_font_override(&"italitc_font", load(custom_italic_font) as Font)
	if !custom_bold_italic_font.is_empty():
		display_text.add_theme_font_override(&"bold_italics_font", load(custom_bold_italic_font) as Font)


	#button_continue.move_to_front()
	continue_container.move_to_front()
	extra_space.move_to_front()
	#continue_container.visible = true


func _on_timer_timeout() -> void:
	dialogic.Text.text_finished.emit(last_text_info)


func get_bottom_scroll() -> int:
	var boxes:int = text_container.get_child_count()
	var scroll_end:int = boxes * 100
	return scroll_end


func scroll_down():
	await(get_tree().physics_frame)
	text_scroll_container.set_v_scroll(get_bottom_scroll())


## Use this to get potential global settings.
func get_global_setting(setting_name:StringName, default:Variant) -> Variant:
	return get_parent().get_global_setting(setting_name, default)


func _on_button_continue_pressed() -> void:
	dialogic.Inputs.handle_input()


#func _on_dialogic_action_priority():
	#button_continue.visible = false
	#print("action_priority")


func _on_dialogic_signal(argument:String):
	match argument:
		"clear":
			clear()
