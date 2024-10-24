extends CharacterBody2D

@export var Projectile : PackedScene

var speed = 200

var x_velocity_sign = 1
var y_velocity_sign = 1

enum States {IDLE, RUN}

var playerBody: CharacterBody2D
var playerDetected: bool

func _ready():
	$MovementTimer.start()

func _physics_process(_delta):
	if playerDetected:
		velocity.x = x_velocity_sign * speed
		velocity.y = y_velocity_sign * speed
		
		# if player is to left of mob, face left
		$AnimatedSprite2D.flip_h = (playerBody.global_position.x - global_position.x) < 0
		
		move_and_slide()

func _on_movement_timer_timeout() -> void:
	if randi() % 2:
		x_velocity_sign = 1
	else:
		x_velocity_sign = -1
	
	if randi() % 2:
		y_velocity_sign = 1
	else:
		y_velocity_sign = -1


func _on_detection_zone_body_entered(body: Node2D):
	if "Wizard" in body.name or "Archer" in body.name:
		playerBody = body
		playerDetected = true
		$AnimatedSprite2D.animation = "run"
		$AnimatedSprite2D.play()


func _on_detection_zone_body_exited(body: Node2D) -> void:
	if "Wizard" in body.name or "Archer" in body.name:
		playerBody = null
		playerDetected = false
		$AnimatedSprite2D.animation = "idle"


func _on_shoot_timer_timeout() -> void:
	shoot() # Replace with function body.
	
func shoot():
	var p = Projectile.instantiate()
	get_tree().current_scene.add_child(p)
	p.global_position = global_position
	if playerDetected:
		look_at(playerBody.global_position)
