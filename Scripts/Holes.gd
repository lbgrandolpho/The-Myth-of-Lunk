extends Area2D

func _on_Holes_body_entered(body):
	if body.is_in_group("Fallables"):
		body.fall()
