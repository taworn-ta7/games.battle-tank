extends Area2D

var base_image = 0
var sprite_left = [base_image + 2, base_image + 4]
var sprite_right = [base_image + 6, base_image + 8]
var sprite_up = [base_image + 0, base_image + 2]
var sprite_down = [base_image + 4, base_image + 6]
var sprite = sprite_up
var velocity = Vector2(0, 0)
var speed = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Check input 4 directions.
	if Input.is_action_pressed("ui_left"):
		velocity.x = -1
		velocity.y = 0
		sprite = sprite_left
	elif Input.is_action_pressed("ui_right"):
		velocity.x = 1
		velocity.y = 0
		sprite = sprite_right
	elif Input.is_action_pressed("ui_up"):
		velocity.x = 0
		velocity.y = -1
		sprite = sprite_up
	elif Input.is_action_pressed("ui_down"):
		velocity.x = 0
		velocity.y = 1
		sprite = sprite_down
	else:
		velocity.x = 0
		velocity.y = 0
		$Sprite.playing = false
		return

	# check boundary
	if velocity.x <= 0 && position.x <= 0:
		velocity.x = 0
		position.x = 0
	if velocity.x >= 0 && position.x >= 1024 - 64:
		velocity.x = 0
		position.x = 1024 - 64
	if velocity.y <= 0 && position.y <= 0:
		velocity.y = 0
		position.y = 0
	if velocity.y >= 0 && position.y >= 600 - 64:
		velocity.y = 0
		position.y = 600 - 64

	# If has input, move.
	if $Sprite.frame < sprite[0] || $Sprite.frame >= sprite[-1]:
		$Sprite.frame = sprite[0]
	if !$Sprite.playing:
		$Sprite.frame = sprite[0]
		$Sprite.playing = true
	translate(velocity * speed)

func _on_Sprite_frame_changed():
	if $Sprite.frame >= sprite[-1]:
		$Sprite.frame = sprite[0]

