extends "res://tank.gd"

# เรียกเมื่อ สร้าง Scene
func _ready():
	pass

# เรียกเรื่อยๆ ทุกเวลา delta ผ่านไป
func _process(delta):
	pass

# เรียกตอนเริ่ม เพื่อเช็ตค่าตัวแปร
func init(base_image, dir, speed, block):
	# เช็ตชุดรถถัง
	self.base_image = base_image
	self.sprite_left = [base_image + 2, base_image + 4]
	self.sprite_right = [base_image + 6, base_image + 8]
	self.sprite_up = [base_image + 0, base_image + 2]
	self.sprite_down = [base_image + 4, base_image + 6]

	# เช็ตทิศทางเริ่มต้น
	self.direction = dir
	if direction == Constants.DIRECTION_LEFT:
		sprite = sprite_left
	elif direction == Constants.DIRECTION_RIGHT:
		sprite = sprite_right
	elif direction == Constants.DIRECTION_UP:
		sprite = sprite_up
	elif direction == Constants.DIRECTION_DOWN:
		sprite = sprite_down
	
	# เช็ตความเร็ว
	self.speed = speed
	
	# เช็ตค่าเริ่มต้น
	var pixel = Constants.block_to_pixel(block)
	self.position = Vector2(pixel.x + Constants.TANK_WIDTH_HALF, pixel.y + Constants.TANK_HEIGHT_HALF)

	# วาดรูป
	$Sprite.frame = sprite[0]

