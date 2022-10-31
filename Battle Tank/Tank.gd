class_name Tank
extends Area2D


# กลุ่มรถถัง
var TankFastGroup = [
	Globals.TankType.YELLOW_FAST_0,
	Globals.TankType.GREEN_FAST_0,
	Globals.TankType.WHITE_FAST_0,
	Globals.TankType.PURPLE_FAST_0,
]
var TankNormalGroup = [
	Globals.TankType.YELLOW_NORMAL_0, Globals.TankType.YELLOW_NORMAL_1, Globals.TankType.YELLOW_NORMAL_2,
	Globals.TankType.GREEN_NORMAL_0, Globals.TankType.GREEN_NORMAL_1, Globals.TankType.GREEN_NORMAL_2,
	Globals.TankType.WHITE_NORMAL_0, Globals.TankType.WHITE_NORMAL_1, Globals.TankType.WHITE_NORMAL_2,
	Globals.TankType.PURPLE_NORMAL_0, Globals.TankType.PURPLE_NORMAL_1, Globals.TankType.PURPLE_NORMAL_2,
]
var TankMediumGroup = [
	Globals.TankType.YELLOW_MEDIUM_0, Globals.TankType.YELLOW_MEDIUM_1,
	Globals.TankType.GREEN_MEDIUM_0, Globals.TankType.GREEN_MEDIUM_1,
	Globals.TankType.WHITE_MEDIUM_0, Globals.TankType.WHITE_MEDIUM_1,
	Globals.TankType.PURPLE_MEDIUM_0, Globals.TankType.PURPLE_MEDIUM_1,
]
var TankLargeGroup = [
	Globals.TankType.YELLOW_LARGE_0, Globals.TankType.YELLOW_LARGE_1,
	Globals.TankType.GREEN_LARGE_0, Globals.TankType.GREEN_LARGE_1,
	Globals.TankType.WHITE_LARGE_0, Globals.TankType.WHITE_LARGE_1,
	Globals.TankType.PURPLE_LARGE_0, Globals.TankType.PURPLE_LARGE_1,
]

# ค่าคงที่สำหรับขนาดรถถัง
var size = Vector2(Globals.TANK_WIDTH, Globals.TANK_HEIGHT)

# sprite
var base_image = 0

# รูปสำหรับ หันซ้าย ขวา ขึ้น ลง
var sprite_left = [base_image + 2, base_image + 4]
var sprite_right = [base_image + 6, base_image + 8]
var sprite_up = [base_image + 0, base_image + 2]
var sprite_down = [base_image + 4, base_image + 6]

# รูปที่กำลังใช้แสดง
var sprite = sprite_up

# ทิศทาง
var direction = Globals.DirectionType.UP

# ความเร็ว
var velocity = Vector2(0, 0)

# กำลังเดิน
var moving = false

# เป้าหมายที่กำลังเดินไป, ถ้ากำลังเดิน
var target = null

# เวลา
var time_used = 0
var seconds_per_pixel = 1  # 8 pixels == 1 unit

# คำสั่งจาก logic controller
var controller = Globals.DirectionType.NONE

# rate of fire, สามารถยิงอีกครั้งได้ในเวลา (วินาที)
var rof = 1
var last_fire_time = 0

# ฝ่าย
var faction = Globals.FactionType.NONE

# เลือด
var hp = 1

# แผนที่
var map

# scene ชั้นบนสุด สำหรับถามค่า playing
var top


# Called when the node enters the scene tree for the first time.
func _ready():
	map = get_parent()
	top = map.get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# เช็ค playing
	if !top.playing():
		return

	# จัดการ rate of fire	
	if last_fire_time > 0:
		last_fire_time -= delta

	# จัดการการเดิน
	if moving:
		# ทำการปรับ animate
		$Sprite.frame = $Sprite.frame + 1
		if !($Sprite.frame >= sprite[0] && $Sprite.frame < sprite[1]):
			$Sprite.frame = sprite[0]

		# กำลังเดินไปที่ target (x, y)
		if position == target:
			moving = false
			controller = Globals.DirectionType.NONE
			#print("stoping at %s" % position)
		else:
			time_used += delta
			if time_used >= seconds_per_pixel:
				time_used = 0
				translate(velocity * 1)
			#print("moving at %s" % position)

	else:
		# เคลื่อนไหวตามคำสั่งชอง logic controller
		if controller == Globals.DirectionType.LEFT:
			direction = Globals.DirectionType.LEFT
			velocity.x = -1
			velocity.y = 0
			target = Vector2(position.x - Globals.UNIT_WIDTH, position.y)
			sprite = sprite_left
			if map.can_move(get_area(), Vector2(-1, 0)):
				moving = true
		elif controller == Globals.DirectionType.RIGHT:
			direction = Globals.DirectionType.RIGHT
			velocity.x = 1
			velocity.y = 0
			target = Vector2(position.x + Globals.UNIT_WIDTH, position.y)
			sprite = sprite_right
			if map.can_move(get_area(), Vector2(1, 0)):
				moving = true
		elif controller == Globals.DirectionType.UP:
			direction = Globals.DirectionType.UP
			velocity.x = 0
			velocity.y = -1
			target = Vector2(position.x, position.y - Globals.UNIT_HEIGHT)
			sprite = sprite_up
			if map.can_move(get_area(), Vector2(0, -1)):
				moving = true
		elif controller == Globals.DirectionType.DOWN:
			direction = Globals.DirectionType.DOWN
			velocity.x = 0
			velocity.y = 1
			target = Vector2(position.x, position.y + Globals.UNIT_HEIGHT)
			sprite = sprite_down
			if map.can_move(get_area(), Vector2(0, 1)):
				moving = true

		$Sprite.frame = sprite[0]
		if moving:
			time_used = 0


# กำหนดค่าเริ่มต้นของรถถัง
func init(tile: int) -> void:
	base_image = tile
	sprite_left = [base_image + 2, base_image + 4]
	sprite_right = [base_image + 6, base_image + 8]
	sprite_up = [base_image + 0, base_image + 2]
	sprite_down = [base_image + 4, base_image + 6]
	if tile in TankFastGroup:
		seconds_per_pixel = 0.017
		rof = 0.35
		hp = 1
	elif tile in TankNormalGroup:
		seconds_per_pixel = 0.035
		rof = 0.50
		hp = 2
	elif tile in TankMediumGroup:
		seconds_per_pixel = 0.070
		rof = 0.75
		hp = 3
	elif tile in TankLargeGroup:
		seconds_per_pixel = 0.100
		rof = 1.00
		hp = 4
	set_face(Globals.DirectionType.UP)


# หันหน้า
func set_face(face: int) -> void:
	direction = face
	if direction == Globals.DirectionType.LEFT:
		sprite = sprite_left
	elif direction == Globals.DirectionType.RIGHT:
		sprite = sprite_right
	elif direction == Globals.DirectionType.UP:
		sprite = sprite_up
	elif direction == Globals.DirectionType.DOWN:
		sprite = sprite_down
	$Sprite.frame = sprite[0]


# ลบ scene นี้ออก
func destroy() -> void:
	get_parent().remove_child(self)
	queue_free()


# ขอพื้นที่
func get_area() -> Rect2:
	return Rect2(position, size)


# ถูกยิง
func get_hit() -> bool:
	hp -= 1
	if hp <= 0:
		destroy()
		return true
	return false


# ตัวควบคุม
func controller(move: int) -> void:
	controller = move


# คำสั่งยิง
func fire() -> void:
	if last_fire_time <= 0:
		var bullet = preload("res://Bullet.tscn").instance()
		map.add_child(bullet)
		last_fire_time = rof

		var v
		var p
		if direction == Globals.DirectionType.LEFT:
			v = Vector2(-1, 0)
			p = Vector2(position.x - 1, position.y + Globals.TANK_HEIGHT_HALF)
			#print("fire left at %s" % p)
		elif direction == Globals.DirectionType.RIGHT:
			v = Vector2(1, 0)
			p = Vector2(position.x + Globals.TANK_WIDTH + 1, position.y + Globals.TANK_HEIGHT_HALF)
			#print("fire right at %s" % p)
		elif direction == Globals.DirectionType.UP:
			v = Vector2(0, -1)
			p = Vector2(position.x + Globals.TANK_WIDTH_HALF, position.y - 1)
			#print("fire up at %s" % p)
		elif direction == Globals.DirectionType.DOWN:
			v = Vector2(0, 1)
			p = Vector2(position.x + Globals.TANK_WIDTH_HALF, position.y + Globals.TANK_HEIGHT + 1)
			#print("fire down at %s" % p)		bullet.init(direction, v, p, faction)

