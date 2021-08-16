extends Control

onready var anim = $AnimationPlayer

func _ready():
	anim.play("End")
