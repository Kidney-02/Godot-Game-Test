extends Button
@export var variable_name = "button_val"

func _on_pressed():
	#print(GlobalVariables.get("number"))
	print(GlobalVariables.get(variable_name))
	pass # Replace with function body.
