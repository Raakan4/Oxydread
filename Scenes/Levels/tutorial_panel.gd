extends Panel
@onready var gun = $"../../PlayerController/Gun"
@onready var tutorialtext = $RichTextLabel
@onready var Image1 = $TextureRect
@onready var nextbutton = $Button
@onready var Image2 = $TextureRect2
var tutorialnumber = -1
@export var imageindex1 : Array[Texture]
@export var tutoriallabelindex : Array[String]
@export var imageindex2 : Array[Texture]

func _ready() -> void:
	gun.WeaponInventory = ["res://Resource/Weapons/Pistol.tres","res://Resource/Weapons/Revolver.tres" ]
	gun.TotalAmmoTempArray = [200,200,0,0]
func next():
	loadTut(tutorialnumber)

func loadTut(number):
	Image1.texture = imageindex1[number]
	Image2.texture = imageindex2[number]
	tutorialtext.text = tutoriallabelindex[number]
	
func _on_button_pressed() -> void:
	print(tutorialnumber)
	tutorialnumber += 1
	if tutorialnumber > 3:
		gun.TotalAmmoTempArray = [200,0,0,0]
		gun.WeaponInventory = ["res://Resource/Weapons/Pistol.tres",]
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
	else:
		next()
