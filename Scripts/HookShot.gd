extends Node2D

const MAX = 100
const SPEED = 2
signal hooked(hit)
var collided = false
var is_barrel = false
var player_pos

func shoot(player):
	position = player.global_position + player.direction * 4
	if player.direction.y == 0:
		position.y += 4
	is_barrel = false
	collided = false
	rotation = player.direction.angle()
	visible = true
	$Line2D.points[0].x = 0
	$Line2D.points[1].x = 0
	$Tip.position.x = 0
	
func retract(amnt):
	$Line2D.points[0].x += amnt
	
func tip():
	return $Tip.global_position
	
func _process(delta):
	
	if visible:
		
		if not is_barrel:
			$Line2D.points[1].x += SPEED
			$Tip.position.x += SPEED
			
		else:
			emit_signal("hooked", true)
			
		
		if abs($Tip.position.x) > MAX or collided:
			visible = false
			emit_signal("hooked", false)

func _on_Area2D_body_entered(body):
	
	if body.name == "Walls":
		collided = true
		
	if body.is_in_group("Barrel"):
		is_barrel = true
		
