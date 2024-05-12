class_name DialogicModernRPGTextboxDisplayText
extends RichTextLabel



func set_info(info: Dictionary, layer: DialogicModernRPGTextboxLayer):
	## info from DialogicTextEvent:
	## 'text':final_text, 'character':character, 'portrait':portrait, 'append': is_append})
	var text_to_display:String
	
	var char_name:String
	var character:DialogicCharacter
	var character_last:DialogicCharacter
	
	if info.has("character") and info.character != null:
		character = info.character
		char_name = character.get_display_name_translated()
		if layer.display_character_names_in_uppercase:
			char_name = char_name.to_upper()
		
		var char_color:Color = character.color
		if char_color == Color.WHITE:
			char_color = Color.BURLYWOOD
		
		char_name = str("[color=#", char_color.to_html(), "]" , char_name , "[/color]")
	elif info.has("button_index"):
		char_name = "YOU"
	
	if layer.last_text_info and layer.last_text_info.has("character"):
		character_last = layer.last_text_info.character
	if character != character_last and char_name != "":
		text_to_display += char_name
		#text_to_display += layer.display_this_string_after_character_name
		text_to_display += "\n"
	
	var info_text:String = info.text
	
	if (character and character.get_character_name() == "whisper"):
		info_text = str("[i][b]", info_text, "[/b][/i]")
	
	if layer.add_quotes_to_dialogue_text:
		if (character and character.get_character_name() != "roll") or char_name == "YOU":
			info_text = '"' + info_text + '"'
	text_to_display += info_text
	
	text = text_to_display
	
	



func fade(to_opacity: float):
	modulate = Color(1,1,1,to_opacity)


