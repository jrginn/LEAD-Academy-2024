extends CharacterBody2D

@export var speed = 800 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$AnimatedSprite2D.play()
	
	get_input()
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		
	move_and_slide()
	
	if velocity.x != 0 or velocity.y != 0: 
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		# See the note below about the following boolean assignment.
		$AnimatedSprite2D.flip_h = velocity.x < 0
	
	if velocity.length() == 0:
		$AnimatedSprite2D.animation = "idle"
		
func get_input():
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_dir * speed
