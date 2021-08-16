extends Area2D

export var SPEED = 100
var direction = Vector2.UP

func _process(delta):
	position += direction * SPEED * delta

func _on_Shoot_body_entered(body):
	if body.name == "Player":
		body.hit(self)

