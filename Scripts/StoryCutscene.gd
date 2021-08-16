extends Control

onready var anim = $Labels/AnimationPlayer
onready var anim2 = $Labels/AnimationPlayer2


func _process(delta):
	anim.play("Cutscene")
	anim2.play("Skip")
	
	if Input.is_action_just_pressed("action"):
		_on_Timer_timeout()

func _on_Timer_timeout():
	get_tree().change_scene("res://Scenes/Node2D.tscn")
