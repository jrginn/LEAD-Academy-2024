extends Node2D

@export var pumpkin_scene: PackedScene
@export var necromancer_scene: PackedScene
@export var chort_scene: PackedScene
@export var doctor_scene: PackedScene

var _character_scene_list = [
	pumpkin_scene, 
	necromancer_scene,
	chort_scene,
	doctor_scene
]

func _process(delta):
	var mob = _character_scene_list[randi() % 4].instantiate()
	
	var mob_spawn_location = location
