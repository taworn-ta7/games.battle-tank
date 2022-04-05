extends "res://tank.gd"

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

