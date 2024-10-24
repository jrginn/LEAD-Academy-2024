extends CharacterBody2D

@export var Projectile : PackedScene

var speed = 800

enum States {IDLE, WALK, ATTACK, HURT, DEATH}
var state: States = States.IDLE: set = set_state
var is_attacking = false

var is_facing_right = true

var should_switch = true

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
	
	#if is_facing_right && rotation == PI:
		#rotation += PI
		#scale.y = 1
	#elif not is_facing_right && rotation == 0:
		#rotation += PI
		#print(rotation)
		#scale.y = -1
	
	if Input.is_action_pressed("left_click"):
		state = States.ATTACK
		shoot()
	elif velocity.x != 0 or velocity.y != 0:
		state = States.WALK
	else:
		state = States.IDLE
	#look_at(get_global_mouse_position())
	#if get_global_mouse_position().x > position.x:
		#flip_h = false
	#elif get_global_mouse_position().x < position.x:
		#flip_h = true
	#if velocity.x < 0:
		#scale = Vector2(-1,1)
	#elif velocity.x > 0:
		#scale = Vector2(1,1)

func set_state(new_state: int):
	state = new_state
	
	if state == States.IDLE:
		$AnimatedSprite2D.animation = "idle"
	elif state == States.WALK:
		$AnimatedSprite2D.animation = "walk"
		#$AnimatedSprite2D.flip_h = not is_facing_right
		#if is_facing_right:
			#$ShootPoint.position.x = abs($ShootPoint.position.x)  # Ensure it's on the right
		#else:
			#$ShootPoint.position.x = -abs($ShootPoint.position.x)  # Flip to the left

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
	#p.look_at(get_global_mouse_position())
	p.transform = $ShootPoint.global_transform
	
