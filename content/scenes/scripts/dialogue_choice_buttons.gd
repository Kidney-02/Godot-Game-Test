extends MarginContainer

#var VBox
var button = preload("res://content/scenes/dialogue/dialogue_button.tscn")

var base_label = preload("res://content/scenes/dialogue/dialogue_label.tscn")
	
	
func makeButtons(choices):
	var buttons = []
	var i = 0
	
	for c in choices:
		buttons.append(button.instantiate())
		
		var btn_name = c.get_slice("\\", 0).dedent() 			# // = /
		var variable = c.get_slice("\\", 1).replace(" ", "")
		var value = c.get_slice("\\", 2).replace(" ", "")
		
		buttons[i].set_text(btn_name)
		buttons[i].btn_val = value
		buttons[i].btn_var = variable
		
		
		$ButtonGroup.add_child(buttons[i])
		
		
		i += 1
		pass
	pass
	
func on_button_clicked(sel_button :String) -> void:
	print("selected button", sel_button)
	
	hide_buttons()	
	add_selected_text(sel_button)
	#print(get_parent().get_owner().can_scroll)
	get_parent().get_owner().can_scroll = true
	
	pass
	
	
func hide_buttons():
	$ButtonGroup.visible = false
	
	pass
	
	
func add_selected_text(sel_button :String):
	
	var sel_dialogue = base_label.instantiate()
	sel_dialogue.get_child(0).text = sel_button
	
	var color = Color(1,0,0,1)
	
	sel_dialogue.get_child(0).set("theme_override_colors/default_color",color)
	
	$".".add_child(sel_dialogue)

	pass

	
		
func clearNode(node :Node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free() 
