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
	pass

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

