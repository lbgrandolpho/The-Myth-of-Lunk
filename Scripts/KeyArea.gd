extends Area2D

onready var parent = get_parent()

func _on_KeyArea_body_entered(body):
	
	if body.name == "Player":
		if body.hasBits(parent.key):
			parent.queue_free()
