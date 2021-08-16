extends Camera2D

const SPEED = 4
var area_change = false
var area_started = false
var transition = false
var direction
var target = Vector2.ZERO
var screen = Vector2(
	ProjectSettings.get_setting("display/window/size/width"),
	ProjectSettings.get_setting("display/window/size/height")
)

onready var shader = $Transition.material
onready var HUD = $"../CanvasLayer/HUD"
onready var anim = $Transition/AnimationPlayer
var spawners = []


func _process(delta):
	
	if transition:
		
		if area_change:
			area_started = true
			
		if not area_started:
			position += direction * SPEED
		
		elif not anim.is_playing():
			
			var d
			
			match direction:
				Vector2.DOWN: d = Vector2(0.5, 0)
				Vector2.UP: d = Vector2(0.5, 1)
				Vector2.LEFT: d = Vector2(0, 0.5)
				Vector2.RIGHT: d = Vector2(1, 0.5)
			
			shader.set_shader_param("center", d)
			anim.play("FadeOut")
			yield(anim, "animation_finished")
			
			match direction:
				Vector2.UP: d = Vector2(0.5, 0)
				Vector2.DOWN: d = Vector2(0.5, 1)
				Vector2.RIGHT: d = Vector2(0, 0.5)
				Vector2.LEFT: d = Vector2(1, 0.5)
				
			shader.set_shader_param("center", d)
			position = target
			anim.play_backwards("FadeOut")
			yield(anim, "animation_finished")
			area_started = false
			
		if position == target:
			transition = false
			HUD.visible = true
			
			for spawner in spawners:
				spawner.gtfo()
			
			spawners.clear()
			var bodies = $Area2D.get_overlapping_areas()
			for body in bodies:
				if body.is_in_group("Spawners"):
					spawners.append(body)
					body.spawn()

func _on_Player_room_leave(rel):
	
	if not transition:
		
		if abs(rel.x) > abs(rel.y):
			direction = Vector2.RIGHT * sign(rel.x)
		else:
			direction = Vector2.DOWN * sign(rel.y)
			
		target = position + screen * direction
		transition = true
	
		HUD.visible = false


func _on_AreaChange_body_entered(body):
	if body.name == "Player":
		area_change = true

func _on_AreaChange_body_exited(body):
	if body.name == "Player":
		area_change = false

func _on_Area2D_body_entered(body):
	if body.is_in_group("Bosses"):
		body.can_shoot = true

func _on_Area2D_body_exited(body):
	if body.is_in_group("Bosses"):
		body.can_shoot = false

func _on_Area2D_area_exited(area):
	if area.is_in_group("Projectiles"):
		area.queue_free()
