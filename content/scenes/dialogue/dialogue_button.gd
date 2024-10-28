extends Button

var btn_val
var btn_var


func _on_pressed():
	
	GlobalVariables.set(btn_var, btn_val) 
	
	get_parent().get_owner().on_button_clicked(self.text)
	pass # Replace with function body.
