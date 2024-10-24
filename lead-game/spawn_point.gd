extends Node2D

@export var pumpkin_scene: PackedScene
@export var necromancer_scene: PackedScene
@export var chort_scene: PackedScene
@export var doctor_scene: PackedScene

var _character_scene_list: Array[PackedScene] = [
	pumpkin_scene, 
	necromancer_scene,
	chort_scene,
	doctor_scene
]

func _ready():
	spawn_mob()
	
func spawn_mob():
	var mob = pumpkin_scene.instantiate()
	mob.global_position = global_position
	add_child(mob)
