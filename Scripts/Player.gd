extends KinematicBody2D

var direction = Vector2.DOWN
var motion = Vector2.ZERO

enum Item {
	PurpleKey,
	RedKey,
	GreenKey,
	BlueKey,
	BossKey,
	Sword,
	HookShot
}

export (Item, FLAGS) var has_item = 0

func hasBits(bits):
	return (has_item & bits) == bits

func has(what):
	return has_item & (1 << what)
	
func give(what):
	has_item |= (1 << what)

signal room_leave(pos)
signal set_health(health)
signal rupix(amnt)

onready var anim = $AnimatedSprite/AnimationPlayer
onready var anim2 = $"../OldMan1/TextSword/AnimationPlayer"
onready var camera = $"../Camera2D"
onready var hookshot = $"../HookShot"

export var MAXSPEED = 10000
export var FRIC = 0.05
export var ACC = 2600
export var KNOCK = 500
export var health = 6
export var rupix = 0

const MAXHEALTH = 6

enum State {Basic, Falling, Hit, Dead, Hooking, Hooked, PickItem, Cutscene}
var state = State.Basic
var hooked = false
var hook_pos

const DIR = {
	Vector2.DOWN: "Down", Vector2.UP: "Up",
	Vector2.LEFT: "Left", Vector2.RIGHT: "Right"
}

func _ready():
	emit_signal("set_health", health)
	emit_signal("rupix_get", rupix)

func _physics_process(delta):
	
	if health <= 0:
		if $TimeToDie.is_stopped():
			die()
			
	if hooked:
		state = State.Hooked
		if ((position - hookshot.tip()) * direction).length() > 2:
				position += 2 * direction
				hookshot.retract(2)
		else:
			hookshot.visible = false
			hooked = false
			state = State.Basic
		
				
	
	if state == State.Basic:
		
		var input = Vector2.ZERO
		
		if not camera.transition:
			input.x = Input.get_action_strength("walk_right") -\
						Input.get_action_strength("walk_left")

			input.y = Input.get_action_strength("walk_down") -\
						Input.get_action_strength("walk_up")
		
		else:
			input = camera.direction
		
		var anim_state = "Idle"
		if input.length() > 0:
			
			anim_state = "Walk"
			direction = input
			if direction.x != 0 and direction.y != 0:
				direction.x = 0
		
		var norm = input.normalized()
		input.x = min(abs(input.x), abs(norm.x)) * sign(norm.x)
		input.y = min(abs(input.y), abs(norm.y)) * sign(norm.y)
		
		motion = motion.linear_interpolate(Vector2.ZERO, FRIC)
		
		$ActionArea.rotation = direction.angle() - PI/2
		
		if Input.is_action_just_pressed("attack") and has(Item.Sword):
			anim.play("Sword" + DIR[direction])
			$SwordHitBox.rotation = direction.angle() - PI/2
			$SwordHitBox/CollisionShape2D.disabled = false
			yield(anim, "animation_finished")
			$SwordHitBox/CollisionShape2D.disabled = true
			
		elif Input.is_action_just_pressed("hook") and has(Item.HookShot):
			state = State.Hooking
			hookshot.shoot(self)
			 
#			$HookShot.shoot(direction)
#			$HookShot.position = direction * 4
			anim.play("Hook" + DIR[direction])
#			if direction.y == 0:
#				$HookShot.position.y = 4
#			else:
#				$HookShot.position.y = 0
				
		elif Input.is_action_just_pressed("action"):
			var bodies = $ActionArea.get_overlapping_bodies()
			
			for body in bodies:
				if body.is_in_group("Chest"):
					body.openChest(self)
					
				elif body.is_in_group("OldMan"):
					anim2.play("TalkText")
					state = State.PickItem
					giveSword()
			
		elif not anim.current_animation.begins_with("Sword"):
			motion += input * ACC * delta
			anim.play(anim_state + DIR[direction])
			
			
		motion = motion.clamped(MAXSPEED)/(1 + int (camera.transition))
		
		if motion.length() <= 0.05:
			motion = Vector2.ZERO
		
		motion = move_and_slide(motion)
		
		var rel = position - camera.position 
		if abs(rel.x) > camera.screen.x/2 or abs(rel.y) > camera.screen.y/2:
			emit_signal("room_leave", rel)
	
	elif state == State.Falling:
		die()
		
	elif state == State.Hit:
		motion = motion.linear_interpolate(Vector2.ZERO, 0.2)
		motion = move_and_slide(motion)
		if motion.length() < 0.5:
			state = State.Basic
			
	elif state == State.PickItem:
		anim.play("PickItem")
		yield(anim, "animation_finished")
		state = State.Basic
		
func fall(): 
	state = State.Falling
	
func hit(body):
	if state == State.Basic:
		var dir = (global_position - body.global_position)
		motion = KNOCK * dir.normalized()
		health -= 1
		emit_signal("set_health", health)
		anim.play("Hurt")
		state = State.Hit

func die():
	state = State.Dead
	anim.play("Death")
	yield(anim, "animation_finished")
	visible = false
	$TimeToDie.start()

func _on_SwordHitBox_body_entered(body):
	if body.is_in_group("Enemies"):
		body.hit(direction)

func _on_HookShot_hooked(hit):
	if hit:
		hooked = true
#		hook_pos = $HookShot/Tip.global_position
	state = State.Basic

func _on_TimeToDie_timeout():
	get_tree().reload_current_scene()

func giveSword():
	give(Item.Sword)

func pickItem():
	state = State.PickItem
	
func basicPlayer():
	if state != State.Basic:
		state = State.Basic
		
func heal():
	if health < MAXHEALTH:
		health += 1
		emit_signal("set_health", health)

func _on_World_end():
	anim.play("PickItem")
	get_parent().get_node("Lunk/AnimatedSprite/AnimationPlayer").play("Hurray")
	state = State.Cutscene


