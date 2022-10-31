class_name HeroTank
extends "res://Tank.gd"


# properties สำหรับค่าเริ่มต้น
export(Globals.TankType) var tile = Globals.TankType.WHITE_NORMAL_0
export(Globals.DirectionType) var face = Globals.DirectionType.RIGHT
export(Vector2) var initial_unit = Vector2(0, 0)


# Called when the node enters the scene tree for the first time.
func _ready():
	faction = Globals.FactionType.HERO
	init(tile)
	hp = 10
	set_face(face)
	position = Vector2(initial_unit.x * Globals.TANK_WIDTH, initial_unit.y * Globals.TANK_HEIGHT)
	var label = map.get_parent().get_node('HpLabel')
	label.text = "HP %s" % hp


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# เช็ค playing
	if !top.playing():
		return

	# กดปุ่มทิศทาง
	if Input.is_action_pressed("ui_left"):
		controller(Globals.DirectionType.LEFT)
	elif Input.is_action_pressed("ui_right"):
		controller(Globals.DirectionType.RIGHT)
	elif Input.is_action_pressed("ui_up"):
		controller(Globals.DirectionType.UP)
	elif Input.is_action_pressed("ui_down"):
		controller(Globals.DirectionType.DOWN)

	# กดปุ่มยิง
	if Input.is_action_pressed("ui_accept"):
		fire()


# ถูกยิง
func get_hit() -> bool:
	var result = .get_hit()
	var label = map.get_parent().get_node('HpLabel')
	label.text = "HP %s" % hp
	return result

