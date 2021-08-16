extends Node2D

export (String, FILE, "*.tscn") var enemy
onready var prefab = load(enemy)
var obj = null

func gtfo():
	
	if obj is KinematicBody2D:
		obj.queue_free()
		obj = null
		
func spawn():
	
	obj = prefab.instance()
	add_child(obj)
