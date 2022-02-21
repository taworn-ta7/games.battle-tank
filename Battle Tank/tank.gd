extends Area2D

var velocity = Vector2(0, 0)
var base = 0
var begin = 0
var end = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Check input 4 directions.
	if Input.is_action_pressed("ui_left"):
		velocity.x = -1
		velocity.y = 0
		begin = base + 2
		end = base + 4
	elif Input.is_action_pressed("ui_right"):
		velocity.x = 1
		velocity.y = 0
		begin = base + 6
		end = base + 8
	elif Input.is_action_pressed("ui_up"):
		velocity.x = 0
		velocity.y = -1
		begin = base + 0
		end = base + 2
	elif Input.is_action_pressed("ui_down"):
		velocity.x = 0
		velocity.y = 1
		begin = base + 4
		end = base + 6

	# If has input, move.
	if velocity.length() > 0:
		if !$Sprite.playing:
			$Sprite.frame = begin
			$Sprite.playing = true
		translate(velocity)

func _on_Sprite_frame_changed():
	if $Sprite.frame >= end:
		$Sprite.frame = begin
