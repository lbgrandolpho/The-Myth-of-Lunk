extends Area2D

func _on_DropHeart_body_entered(body):
	if body.name == "Player":
		body.heal()
		queue_free()
