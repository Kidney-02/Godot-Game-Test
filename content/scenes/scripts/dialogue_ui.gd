extends Control

var VBox
var ScrollCont
var base_label = preload("res://content/scenes/dialogue/dialogue_label.tscn")
var base_button_group = preload("res://content/scenes/dialogue/dialogue_choice_buttons.tscn")

var text_file :String = "res://content/dialogue/test_dialogue.txt"
var line_num = 0
#var dialogue = []
var text_dlg
var line_count

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
	
	
	text_dlg = loadFile(text_file)	
	line_count = text_dlg.countn("\n")
	print(line_count)
	
	
func _process(delta):
	pass
	
#
func _input(event):
	if not on_screen:
		return
			
	if event.is_action_pressed("NewLine"):
		if not can_scroll:
			return
			
		#print(event)
		addLine(text_dlg)
	elif event.is_action_pressed("Exit"):
		exit_dialogueUI()
		

	
####################################  Parse Text File  ################################
func addLine(text: String):
	
	if line_num > line_count:
		return
		
	
	var line = readLine(text)
	var line_start = line.get_slice(" ", 0)
	
	match line_start:
		"::":
			
			can_scroll = false
			
			var num_buttons = int(line.get_slice(" ", 1))
			#print(num_buttons)
			
			var choices = []
			for i in range(num_buttons):
				var choice = readLine(text)
				#print(i, choice)
				choices.append(choice)
			
			var buttons = base_button_group.instantiate()
			buttons.makeButtons(choices)
			
			VBox.add_child(buttons)
			pass
			
		">>": # jump to
			var jump_tag = line.get_slice(" ", 1)
			print(jump_tag)
			
			jump_to(text, jump_tag, true)
			
			line = readLine(text)
			new_dialogue_line(line)
			pass			
		
		"<<fileover>>":
			pass		
		
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
		
		if line_num > line_count:			
			return "<<fileover>>"
			
	return line
	
	
func jump_to(text: String, jump_tag: String, forward: bool):
	var jump_line
	
	if forward:
		jump_line = line_num + 1
	else:
		jump_line = 0
		
	var line = ""
	
	#line_num = find_jump_line(jump_tag, jump_line, text)
	while jump_line < line_count:
		
		line = text.get_slice("\n", jump_line)


		jump_line += 1
		if line.left(2) == "<<"  && line.right(-3) == jump_tag:
			break
	
	line_num = jump_line
	
	pass


func find_jump_line(jump_tag :String, jump_line: int, text :String):
	
	var line = text.get_slice("\n", jump_line)
	print (line)
	
	if line.left(2) == "<<" :
		return jump_line
	
	jump_line += 1
	#find_jump_line(jump_tag, jump_line, text)
	
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
	

	
	
	
	
	
	
	
	
