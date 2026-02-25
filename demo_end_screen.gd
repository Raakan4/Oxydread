extends Control


func _on_button_pressed() -> void:
	get_tree().reload_current_scene()


func _on_game_manager_beaten_demo() -> void:
	$Button.disabled = false
	self.visible = true
