extends CharacterBody2D

@export var Projectile : PackedScene

var speed = 800

enum States {IDLE, WALK, ATTACK, HURT, DEATH}
var state: States = States.IDLE: set = set_state
var is_attacking = false

var is_facing_right = true

var health = 5

func get_input():
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_dir * speed

func _physics_process(delta):
	get_input()
	move_and_slide()
	
	$AnimatedSprite2D.play()
	
	is_facing_right = velocity.x >= 0
	
	if Input.is_action_pressed("move_right"): 
		scale.x =  scale.y * 1
	elif Input.is_action_pressed("move_left"):
		scale.x =  scale.y * -1
	
	
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

	elif state == States.ATTACK:
		is_attacking = true
		$AnimatedSprite2D.animation = "attack"
		$AnimatedSprite2D.connect("animation_finished", func(): _on_attack_finished(), CONNECT_ONE_SHOT)

func _on_attack_finished():
	is_attacking = false
	state = States.IDLE
	
func shoot():
	await get_tree().create_timer(.2).timeout
	var p = Projectile.instantiate()
	get_tree().current_scene.add_child(p)
	p.transform = $ShootPoint.global_transform
	p.scale = Vector2(4,4)
	
func hurt():
	health -= 1
	
