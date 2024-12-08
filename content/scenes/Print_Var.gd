extends Button
#@export var variable_name = "button_val"
@export var variable_names = [1]


func _on_pressed():
	#print(GlobalVariables.get("number"))
	
	for n in variable_names:
		print(GlobalVariables.get(n))
	
	
	pass # Replace with function body.
