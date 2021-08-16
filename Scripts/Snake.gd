extends KinematicBody2D

const directions = [Vector2.UP, Vector2.DOWN, Vector2.RIGHT, Vector2.LEFT]
var current
enum State {Alive, Hit, Dead}
var state = State.Alive
export var health = 4
onready var anim = $AnimatedSprite/AnimationPlayer
onready var heart = preload("res://Prefabs/DropHeart.tscn")
const anim_dir = {Vector2.UP: "WalkUp", Vector2.DOWN: "WalkDown", Vector2.RIGHT: "WalkRight", Vector2.LEFT: "WalkLeft"}

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
		
		anim.play(anim_dir[current])
		
	elif state == State.Hit or state == State.Dead:
		motion = motion.linear_interpolate(Vector2.ZERO, 0.2)
		if motion.length() < 0.5 and state != State.Dead:
			state = State.Alive
		
	motion = move_and_slide(motion, Vector2.ZERO)
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
	anim.play("Hurt")
	
	if health <= 0:
		state = State.Dead

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		body.hit(self)
		
func dropHeart():
	if randf() < 0.3:
		var h = heart.instance()
		h.position = position
		get_parent().add_child(h)
