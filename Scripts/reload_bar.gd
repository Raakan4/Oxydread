extends Control

@onready var Progress_Bar = $ProgressBar
@onready var Reloadtimer = $ReloadTimer
@onready var time = $ReloadTimer.wait_time

func _ready() -> void:
	set_process(false)

func _on_gun_reload_bar_signal(ReloadTimerTime: Variant) -> void:
	Progress_Bar.visible = true
	Reloadtimer.wait_time = ReloadTimerTime.wait_time
	Progress_Bar.max_value = Reloadtimer.wait_time
	Reloadtimer.start()
	set_process(true)
	
func _process(delta: float) -> void:
	Progress_Bar.value = Reloadtimer.time_left



func _on_reload_timer_timeout() -> void:
	set_process(false)
	Progress_Bar.visible = false
