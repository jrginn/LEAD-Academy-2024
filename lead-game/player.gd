extends CharacterBody2D

@export var Projectile : PackedScene

var speed = 800

enum States {IDLE, WALK, ATTACK, HURT, DEATH}
var state: States = States.IDLE: set = set_state
var is_attacking = false

func get_input():
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_dir * speed

func _physics_process(delta):
	get_input()
	move_and_slide()
	
	$AnimatedSprite2D.play()
	
	if is_attacking: return # do not change animations before attack has completed
	
	if Input.is_action_pressed("left_click"):
		state = States.ATTACK
		shoot()
	elif velocity.x != 0 or velocity.y != 0:
		state = States.WALK
	else:
		state = States.IDLE

func set_state(new_state: int):
	state = new_state
	
	if state == States.IDLE:
		$AnimatedSprite2D.animation = "idle"
	elif state == States.WALK:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif state == States.ATTACK:
		is_attacking = true
		$AnimatedSprite2D.animation = "attack"
		$AnimatedSprite2D.connect("animation_finished", func(): _on_attack_finished(), CONNECT_ONE_SHOT)

func _on_attack_finished():
	is_attacking = false
	state = States.IDLE
	
func shoot():
	var p = Projectile.instantiate()
	get_tree().current_scene.add_child(p)
	p.transform = $ShootPoint.global_transform
