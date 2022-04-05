extends Area2D

# รูป
var base_image = 0
var sprite_left = [base_image + 2, base_image + 4]
var sprite_right = [base_image + 6, base_image + 8]
var sprite_up = [base_image + 0, base_image + 2]
var sprite_down = [base_image + 4, base_image + 6]
var sprite = sprite_up
var move = false
var direction = Constants.DIRECTION_UP

# ความเร็ว
var velocity = Vector2(0, 0)
var speed = 4

# เรียกเมื่อ สร้าง Scene
func _ready():
	pass # Replace with function body.

# เรียกเรื่อยๆ ทุกเวลา delta ผ่านไป
func _process(delta):
	# กด Space ยิง
	if Input.is_action_pressed("ui_accept"):
		print("shoot!")
		var bullet = preload("res://bullet.tscn").instance()
		get_parent().add_child(bullet)
		pass
		
	# Check input 4 directions.
	if Input.is_action_pressed("ui_left"):
		velocity.x = -1
		velocity.y = 0
		sprite = sprite_left
		move = true
		direction = Constants.DIRECTION_LEFT
	elif Input.is_action_pressed("ui_right"):
		velocity.x = 1
		velocity.y = 0
		sprite = sprite_right
		move = true
		direction = Constants.DIRECTION_RIGHT
	elif Input.is_action_pressed("ui_up"):
		velocity.x = 0
		velocity.y = -1
		sprite = sprite_up
		move = true
		direction = Constants.DIRECTION_UP
	elif Input.is_action_pressed("ui_down"):
		velocity.x = 0
		velocity.y = 1
		sprite = sprite_down
		move = true
		direction = Constants.DIRECTION_DOWN
	else:
		velocity.x = 0
		velocity.y = 0
		move = false
		$Sprite.playing = false
		return

	# check boundary
	var area = get_area()
	if velocity.x <= 0 && area.position.x <= Constants.AREA_LEFT:
		velocity.x = 0
		position.x = Constants.AREA_LEFT + Constants.TANK_WIDTH_HALF
	if velocity.x >= 0 && area.end.x >= Constants.AREA_RIGHT:
		velocity.x = 0
		position.x = Constants.AREA_RIGHT - Constants.TANK_WIDTH_HALF
	if velocity.y <= 0 && area.position.y <= Constants.AREA_UP:
		velocity.y = 0
		position.y = Constants.AREA_UP + Constants.TANK_HEIGHT_HALF
	if velocity.y >= 0 && area.end.y >= Constants.AREA_DOWN:
		velocity.y = 0
		position.y = Constants.AREA_DOWN - Constants.TANK_HEIGHT_HALF

	# If has input, move.
	if $Sprite.frame < sprite[0] || $Sprite.frame >= sprite[-1]:
		$Sprite.frame = sprite[0]
	if !$Sprite.playing:
		$Sprite.frame = sprite[0]
		$Sprite.playing = true
	translate(velocity * speed)

# เรียกเมื่อ animation frame เปลี่ยน
func _on_Sprite_frame_changed():
	if $Sprite.frame >= sprite[-1]:
		$Sprite.frame = sprite[0]

# get area
func get_area():
	return Rect2(
		Vector2(position.x - Constants.TANK_WIDTH_HALF, position.y - Constants.TANK_HEIGHT_HALF),
		Vector2(Constants.TANK_WIDTH, Constants.TANK_HEIGHT)
	)

