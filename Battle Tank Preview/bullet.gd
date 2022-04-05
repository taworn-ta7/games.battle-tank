extends Node2D

# ทิศทาง
var direction = Constants.DIRECTION_UP

# ความเร็ว
var speed = 4
var velocity = Vector2(0, 0)

# กำหนดค่าเริ่มต้น
func init(dir, pos):
	direction = dir
	position = pos
	if direction == Constants.DIRECTION_LEFT:
		velocity.x = -1
	elif direction == Constants.DIRECTION_RIGHT:
		velocity.x = 1
	elif direction == Constants.DIRECTION_UP:
		velocity.y = -1
	elif direction == Constants.DIRECTION_DOWN:
		velocity.y = 1

# เรียกเรื่อยๆ ทุกเวลา delta ผ่านไป
func _process(delta):
	# เช็คขอบ
	var area = get_area()
	if velocity.x <= 0 && area.position.x <= Constants.AREA_LEFT:
		destroy()
	elif velocity.x >= 0 && area.end.x >= Constants.AREA_RIGHT:
		destroy()
	if velocity.y <= 0 && area.position.y <= Constants.AREA_UP:
		destroy()
	elif velocity.y >= 0 && area.end.y >= Constants.AREA_DOWN:
		destroy()

	translate(velocity * speed)
	
# ลบ Scene นี้ออก
func destroy():
	get_parent().remove_child(self)
	queue_free()

# ขอพื้นที่
func get_area():
	return Rect2(
		Vector2(position.x - Constants.BULLET_WIDTH_HALF, position.y - Constants.BULLET_HEIGHT_HALF),
		Vector2(Constants.BULLET_WIDTH, Constants.BULLET_HEIGHT)
	)

