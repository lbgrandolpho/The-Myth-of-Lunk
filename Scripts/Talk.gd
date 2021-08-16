extends Sprite

onready var anim = $AnimationPlayer

func _process(delta):
	anim.play("Talk")



