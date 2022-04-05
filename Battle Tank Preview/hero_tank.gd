extends Area2D

# รูป
var base_image = 0
var sprite_left = [base_image + 2, base_image + 4]
var sprite_right = [base_image + 6, base_image + 8]
var sprite_up = [base_image + 0, base_image + 2]
var sprite_down = [base_image + 4, base_image + 6]

# เคลื่อนไหว
var move = false

# ทิศทาง
var direction = Constants.DIRECTION_UP
var sprite = sprite_up

# ความเร็ว
var speed = 2
var velocity = Vector2(0, 0)

# อัตราการยิง, หน่วยเป็นวินาที
var rate_of_fire = 1
var rof = 0

# เรียกเมื่อ สร้าง Scene
func _ready():
	pass

# เรียกเรื่อยๆ ทุกเวลา delta ผ่านไป
func _process(delta):
	# ลดเวลาการยิง, ถ้าเพิ่งยิงออกไป
	if rof > 0:
		rof -= delta
	
	# กด Space ยิง
	if Input.is_action_pressed("ui_accept"):
		if rof <= 0:
			rof = rate_of_fire
			shoot()
		
	# กดปุ่มทิศทาง
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

	# เช็คขอบ
	var area = get_area()
	if velocity.x <= 0 && area.position.x <= Constants.AREA_LEFT:
		velocity.x = 0
		position.x = Constants.AREA_LEFT + Constants.TANK_WIDTH_HALF
	elif velocity.x >= 0 && area.end.x >= Constants.AREA_RIGHT:
		velocity.x = 0
		position.x = Constants.AREA_RIGHT - Constants.TANK_WIDTH_HALF
	if velocity.y <= 0 && area.position.y <= Constants.AREA_UP:
		velocity.y = 0
		position.y = Constants.AREA_UP + Constants.TANK_HEIGHT_HALF
	elif velocity.y >= 0 && area.end.y >= Constants.AREA_DOWN:
		velocity.y = 0
		position.y = Constants.AREA_DOWN - Constants.TANK_HEIGHT_HALF

	# ถ้ามีการเคลื่อนไหว
	if move:
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

# ยิง
func shoot():
	var bullet = preload("res://bullet.tscn").instance()
	get_parent().add_child(bullet)

	if direction == Constants.DIRECTION_LEFT:
		bullet.init(direction, Vector2(position.x - Constants.TANK_WIDTH_HALF, position.y))
	elif direction == Constants.DIRECTION_RIGHT:
		bullet.init(direction, Vector2(position.x + Constants.TANK_WIDTH_HALF, position.y))
	elif direction == Constants.DIRECTION_UP:
		bullet.init(direction, Vector2(position.x, position.y - Constants.TANK_HEIGHT_HALF))
	elif direction == Constants.DIRECTION_DOWN:
		bullet.init(direction, Vector2(position.x, position.y + Constants.TANK_HEIGHT_HALF))

# ขอพื้นที่
func get_area():
	return Rect2(
		Vector2(position.x - Constants.TANK_WIDTH_HALF, position.y - Constants.TANK_HEIGHT_HALF),
		Vector2(Constants.TANK_WIDTH, Constants.TANK_HEIGHT)
	)

# เกิดการชน
func _on_HeroTank_body_entered(_body):
	print("Tank Hit!")

