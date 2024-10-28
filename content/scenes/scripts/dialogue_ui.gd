extends Control

var VBox
var ScrollCont
var base_label = preload("res://content/scenes/dialogue/dialogue_label.tscn")
var base_button_group = preload("res://content/scenes/dialogue/dialogue_choice_buttons.tscn")

var text_file :String = "res://content/dialogue/test_dialogue.txt"
var line_num = 0
#var dialogue = []
var text_dlg

var on_screen :bool = false

var scroll_has_changed :bool = false
var start_scroll = 0
var stop_scroll = 0
var scroll_lerp_alpha = 0

var can_scroll :bool = true


func _ready() -> void:	
	VBox = $MarginContainer/ScrollContainer/VBox
	ScrollCont = $MarginContainer/ScrollContainer
	
	clearNode(VBox)
	
	#base_label.get_child(0).text = ""
	
	#label.get_child(0).text = loadFile(text_file)
	#VBox.add_child(button_group)
	text_dlg = loadFile(text_file)
	#label.get_child(0).text = ""
	
func _process(delta):
	pass
	
#
func _shortcut_input(event):
	if not on_screen:
		return
			
	if Input.is_action_just_pressed("NewLine"):
		if not can_scroll:
			return
		
		#print(event)
		addLine(text_dlg)
	elif Input.is_action_just_pressed("Exit"):
		exit_dialogueUI()
		

	
####################################  Parse Text File  ################################
func addLine(dlg_text: String):
	
	
	var line = readLine(dlg_text)
	var line_start = line.get_slice(" ", 0)
	
	match line_start:
		"::":
			
			can_scroll = false
			
			var num_buttons = int(line.get_slice(" ", 1))
			#print(num_buttons)
			
			var choices = []
			for i in range(num_buttons):
				var choice = readLine(dlg_text)
				#print(i, choice)
				choices.append(choice)
			
			var buttons = base_button_group.instantiate()
			buttons.makeButtons(choices)
			
			VBox.add_child(buttons)
			
			
			pass
			
		">>": # jump to
			var jump_tag = line.get_slice(" ", 1)
			print(jump_tag)
			
			jump_to(dlg_text, jump_tag, true)
			
			line = readLine(dlg_text)
			new_dialogue_line(line)
			pass			
			
		#"":
			#pass			
		
		_:	## DEFAULT
			
			new_dialogue_line(line)
			
			
			pass
			
	
	scrollDown()
	

func exit_dialogueUI() -> void:
	on_screen = false
	self.visible = false
	
	
func readLine(text: String) -> String:
	var line = ""
	while line == "" or line.left(1) == "#":
		line = text.get_slice("\n", line_num)

		line_num += 1
	
	return line
	
	
func jump_to(text: String, jump_tag: String, forward: bool):
	var jump_line
	
	if forward:
		jump_line = line_num + 1
	else:
		jump_line = 0
		
	var line = ""
	
	while line.left(2) != "<<":
		line = text.get_slice("\n", jump_line)
		jump_line += 1
		
	line_num = jump_line
	
	pass


func new_dialogue_line(line :String) -> void:
	var dialogue = base_label.instantiate()
	dialogue.get_child(0).text = line + " "
	VBox.add_child(dialogue)
	
	pass

func clearNode(node :Node):
	
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()
		

func loadFile(file :String) -> String:
	
	var f = FileAccess.open(file, FileAccess.READ)
	var text = f.get_as_text()
	#print(text)
	return text
	

	
func scrollDown() -> void:
	
	await ScrollCont.get_v_scroll_bar().changed
	

	ScrollCont.scroll_vertical = ScrollCont.get_v_scroll_bar().get_max()
	

	
	
	
	
	
	
	
	
