extends KinematicBody2D

const directions = [Vector2.UP, Vector2.DOWN, Vector2.RIGHT, Vector2.LEFT]
var current
enum State {Alive, Hit, Dead, Attack}
var state = State.Alive
export var health = 6
var can_shoot = false
onready var anim = $AnimatedSprite/AnimationPlayer
onready var heart = preload("res://Prefabs/DropHeart.tscn")
const anim_dir = {Vector2.UP: "WalkUp", Vector2.DOWN: "WalkDown", Vector2.RIGHT: "WalkRight", Vector2.LEFT: "WalkLeft"}
const hurt_dir = {Vector2.UP: "HurtUp", Vector2.DOWN: "HurtDown", Vector2.RIGHT: "HurtRight", Vector2.LEFT: "HurtLeft"}
const attack_dir = {Vector2.UP: "AttackUp", Vector2.DOWN: "AttackDown", Vector2.RIGHT: "AttackRight", Vector2.LEFT: "AttackLeft"}

export (PackedScene) var Shoot

var motion = Vector2.ZERO

func newDirection():
	current = directions[rand_range(0, len(directions))]

func _ready():
	
	randomize()
	newDirection()
	
func _physics_process(delta):
	if state == State.Alive:
		if is_on_wall():
			newDirection()
		
		motion = current * 2000 * delta
		motion = move_and_slide(motion, Vector2.ZERO)
		
		anim.play(anim_dir[current])
		
	elif state == State.Hit or state == State.Dead:
		motion = motion.linear_interpolate(Vector2.ZERO, 0.2)
		if motion.length() < 0.5 and state != State.Dead:
			state = State.Alive
		
	
	if state == State.Dead:
			anim.play("Death")
			yield(anim, "animation_finished")
			queue_free()

func _on_Timer_timeout():
	newDirection()
	$Timer.wait_time = randf() * 2 + 1
	
func hit(direction):
	state = State.Hit
	health -= 1
	motion = direction * 500
	anim.play(hurt_dir[current])
	
	if health <= 0:
		state = State.Dead

func shoot():
	var b = Shoot.instance()
	b.direction = current
	owner.add_child(b)
	b.transform = $Position2D.global_transform

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		body.hit(self)


func _on_ShootTimer_timeout():
	if can_shoot:
		state = State.Attack
		anim.play(attack_dir[current])
		yield(anim, "animation_finished")
		shoot()
		state = State.Alive
	$ShootTimer.wait_time = randf() * 2 + 1
	
func dropHeart():
	var h = heart.instance()
	h.global_position = global_position
	get_parent().add_child(h)
