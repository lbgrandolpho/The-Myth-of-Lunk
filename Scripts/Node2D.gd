extends Node2D

onready var anim = $End/AnimationPlayer

signal end()

func _on_End_body_entered(body):
	if body.name == "Player":
		emit_signal("end")
		$CanvasLayer/HUD.visible = false
		anim.play("End")
		yield(anim, "animation_finished")
		get_tree().change_scene("res://Scenes/TheEnd.tscn")
