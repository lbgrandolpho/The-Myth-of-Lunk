extends Control

onready var heart_container = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer
onready var rublox_counter = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer2/Label
onready var anim = $TextSword/AnimationPlayer

func _on_Player_set_health(health):
	heart_container.renderHearts(health)


func _on_Player_rublox_get(amnt):
	rublox_counter.text = str(amnt)
	
func getItem(item):
	$TextSword/Label.text = "You got " + item
	anim.play("GotItem")
