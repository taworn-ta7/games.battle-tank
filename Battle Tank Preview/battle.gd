extends Node2D

# เรียกเมื่อ สร้าง Scene
func _ready():
	init()

# เรียกเรื่อยๆ ทุกเวลา delta ผ่านไป
func _process(delta):
	pass

# เรียกตอนเริ่ม เพื่อเช็ตค่าตัวแปร
func init():
	$EnemyTank01.init(8, Constants.DIRECTION_DOWN, 1, 2, Vector2(2, 0))
	$EnemyTank02.init(233, Constants.DIRECTION_DOWN, 1, 4, Vector2(4, 0))

