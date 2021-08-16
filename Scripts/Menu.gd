extends Control

onready var anim = $Logo/AnimationPlayer

func _ready():
	$VBoxContainer/StartButton.grab_focus()

func _process(delta):
	anim.play("Fade")
	

func _on_StartButton_pressed():
	get_tree().change_scene("res://Scenes/StoryCutscene.tscn")

func _on_QuitButton_pressed():
	get_tree().quit()

