extends Node2D
@onready var playbutton = $Button
@onready var tutorialbutton = $Button2
@onready var creditsbutton = $Button3
@onready var logo = $TextureRect
@onready var Credits = $Panel
func HideMenu():
	playbutton.visible = false
	tutorialbutton.visible = false
	creditsbutton.visible = false
	playbutton.disabled = true
	tutorialbutton.disabled = true
	creditsbutton.disabled = true
	logo.visible = false
	
func ShowMenu():
	playbutton.visible = true
	tutorialbutton.visible = true
	creditsbutton.visible = true
	playbutton.disabled = false
	tutorialbutton.disabled = false
	creditsbutton.disabled = false
	logo.visible = true
	
func ShowCredits():
	Credits.visible = true
	$Panel/ReturnCreditButton.disabled = false
func HideCredits():
	Credits.visible = false
	$Panel/ReturnCreditButton.disabled = true

func _on_button_pressed() -> void: # play
	get_tree().change_scene_to_file("res://Startbutnotreally.tscn")


func _on_button_2_pressed() -> void: # Tutorial
	get_tree().change_scene_to_file("res://Scenes/Levels/TutorialLevel.tscn")


func _on_button_3_pressed() -> void: # Credits
	HideMenu()
	ShowCredits()
	
func _on_return_credit_button_pressed() -> void:
	ShowMenu()
	HideCredits()
