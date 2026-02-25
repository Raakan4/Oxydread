extends Control

@onready var AmmoScreen = $AmmoLabel
@onready var HealthLabel = $TextureRect2/HealthLabel
@onready var Ammolabel = $TextureRect/AmmoLabel
@onready var TimeLabel = $TextureRect3/TimeLabel
@onready var timer = $Timer
@onready var blackrect = $ColorRect
@onready var animplayer = $AnimationPlayer
@export var timerwait : int
@onready var player = get_tree().get_first_node_in_group("Player")
var counting = true
var min : float
var sec : float
func _on_gun_ammo_change(NewClipSize: Variant, NewCurrentAmmo: Variant, NewTotalAmmo: Variant) -> void:
	Ammolabel.text = str(NewCurrentAmmo) + "/" + str(NewTotalAmmo)


func fadein():
	animplayer.play("FadeToBlack")
	
func fadeout():
	animplayer.play("FadeToNormal")

func hideUI():
	$TextureRect.visible = false
	$TextureRect2.visible = false
	$TextureRect3.visible = false

func unhideUI():
	$TextureRect.visible = true
	$TextureRect2.visible = true
	$TextureRect3.visible = true

func _on_player_controller_health_change(NewHealth: Variant) -> void:
	HealthLabel.text = "Health: " + str(NewHealth)

func _on_player_controller_died() -> void:
	self.visible = false

func resetcount():
	timer.stop()
	timer.wait_time = timerwait

func _ready() -> void:
	timer.wait_time = timerwait
	timer.start()

func pause():
	timer.paused = true

func unpause():
	timer.paused = false

func _process(delta: float) -> void:
	if counting == true:
		min = int(timer.time_left / 60)
		sec = timer.time_left - (min * 60)
		TimeLabel.text = "%02d : %02d" % [min, sec]
	else:
		pass
func _on_timer_timeout() -> void:
	player.Startinghealth = 0 # Replace with function body.
