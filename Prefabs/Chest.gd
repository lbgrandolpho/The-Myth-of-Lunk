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

const spr = {
	Item.PurpleKey: Rect2(68, 0, 7, 16),
	Item.RedKey: Rect2(20, 0, 7, 16),
	Item.GreenKey: Rect2(51, 0, 9, 16),
	Item.BlueKey: Rect2(36, 1, 7, 15),
	Item.BossKey: Rect2(114, 0, 11, 16)
}

onready var anim = $AnimatedSprite/AnimationPlayer

export (Item) var item

func openChest(body):
	if not opened and body.position.y > position.y:
		player = body
		$Item.region_rect = spr[item]
		get_tree().get_nodes_in_group("HUD")[0].getItem(Item.keys()[item])
		anim.play("OpenChest")
		opened = true
		yield(anim, "animation_finished")
		player.give(item)
		anim.play("Open")

func playerPick():
	player.state = player.State.PickItem 

