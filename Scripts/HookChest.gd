extends StaticBody2D

var player
var opened = false

enum Item {
	PurpleKey,
	RedKey,
	GreenKey,
	BlueKey,
	BossKey,
	Sword,
	HookShot
}

onready var anim = $AnimatedSprite/AnimationPlayer

export (Item) var item

func openChest(body):
	if not opened and body.position.y > position.y:
		player = body
		get_tree().get_nodes_in_group("HUD")[0].getItem(Item.keys()[item])
		anim.play("OpenChest")
		opened = true
		yield(anim, "animation_finished")
		player.give(item)
		anim.play("Open")

func playerPick():
	player.state = player.State.PickItem 
