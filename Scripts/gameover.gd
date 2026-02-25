extends Control


func _on_player_controller_died() -> void:
	self.visible = true
	$Button.disabled = false
	$Return.disabled = true

func _on_button_pressed() -> void:
	get_tree().reload_current_scene()


func _on_return_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
