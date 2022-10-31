extends Area2D


# ทิศทาง
var direction = Globals.DirectionType.UP

# ความเร็ว
var velocity = Vector2(0, 0)

# ฝ่าย
var faction = Globals.FactionType.NONE

# แผนที่
var map


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	translate(velocity * 2)
	if map.hit_test(position, direction, faction):
		destroy()


# กำหนดค่าเริ่มต้น จากปากกระบอกปืน
func init(dir: int, v: Vector2, p: Vector2, fac: int) -> void:
	direction = dir
	velocity = v
	position = p
	faction = fac
	map = get_parent()


# ลบ scene นี้ออก
func destroy() -> void:
	get_parent().remove_child(self)
	queue_free()

