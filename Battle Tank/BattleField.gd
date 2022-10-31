extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


# ตรวจสอบว่า รถถัง สามารถเคลื่อนผ่านไปได้หรือไม่?
func can_move(place: Rect2, to: Vector2) -> bool:
	if to.x < 0:
		var to_test = place.position.x + to.x
		if to_test < Globals.AREA_LEFT:
			return false
		var unit = Globals.pixel_to_unit(Vector2(to_test, place.position.y))
		return $TileMap.get_cell(unit.x, unit.y) <= TileMap.INVALID_CELL && $TileMap.get_cell(unit.x, unit.y + 1) <= TileMap.INVALID_CELL

	elif to.x > 0:
		var to_test = place.end.x + to.x
		if to_test > Globals.AREA_RIGHT:
			return false
		var unit = Globals.pixel_to_unit(Vector2(to_test, place.position.y))
		return $TileMap.get_cell(unit.x, unit.y) <= TileMap.INVALID_CELL && $TileMap.get_cell(unit.x, unit.y + 1) <= TileMap.INVALID_CELL

	elif to.y < 0:
		var to_test = place.position.y + to.y
		if to_test < Globals.AREA_UP:
			return false
		var unit = Globals.pixel_to_unit(Vector2(place.position.x, to_test))
		return $TileMap.get_cell(unit.x, unit.y) <= TileMap.INVALID_CELL && $TileMap.get_cell(unit.x + 1, unit.y) <= TileMap.INVALID_CELL

	elif to.y > 0:
		var to_test = place.end.y + to.y
		if to_test > Globals.AREA_DOWN:
			return false
		var unit = Globals.pixel_to_unit(Vector2(place.position.x, to_test))
		return $TileMap.get_cell(unit.x, unit.y) <= TileMap.INVALID_CELL && $TileMap.get_cell(unit.x + 1, unit.y) <= TileMap.INVALID_CELL

	return true


# ตรวจสอบว่า กระสุน ยิงโดนอะไรหรือไม่?
func hit_test(pos: Vector2, dir: int, fac: int) -> bool:
	var u
	var v

	# ทดสอบกำแพง
	if dir == Globals.DirectionType.LEFT:
		if pos.x < Globals.AREA_LEFT:
			boom(pos, Globals.SoundType.WALL)
			return true
		u = Globals.pixel_to_unit(Vector2(pos.x, pos.y - Globals.AMMO_HEIGHT_HALF))
		v = Globals.pixel_to_unit(Vector2(pos.x, pos.y + Globals.AMMO_HEIGHT_HALF))
	elif dir == Globals.DirectionType.RIGHT:
		if pos.x >= Globals.AREA_RIGHT:
			boom(pos, Globals.SoundType.WALL)
			return true
		u = Globals.pixel_to_unit(Vector2(pos.x, pos.y - Globals.AMMO_HEIGHT_HALF))
		v = Globals.pixel_to_unit(Vector2(pos.x, pos.y + Globals.AMMO_HEIGHT_HALF))
	elif dir == Globals.DirectionType.UP:
		if pos.y < Globals.AREA_UP:
			boom(pos, Globals.SoundType.WALL)
			return true
		u = Globals.pixel_to_unit(Vector2(pos.x - Globals.AMMO_WIDTH_HALF, pos.y))
		v = Globals.pixel_to_unit(Vector2(pos.x + Globals.AMMO_WIDTH_HALF, pos.y))
	elif dir == Globals.DirectionType.DOWN:
		if pos.y >= Globals.AREA_DOWN:
			boom(pos, Globals.SoundType.WALL)
			return true
		u = Globals.pixel_to_unit(Vector2(pos.x - Globals.AMMO_WIDTH_HALF, pos.y))
		v = Globals.pixel_to_unit(Vector2(pos.x + Globals.AMMO_WIDTH_HALF, pos.y))

	# ทดสอบสิ่งกีดขวาง
	var r0 = false
	var r1 = false
	r0 = hit_obstacle(u)
	r1 = hit_obstacle(v)
	if r0 || r1:
		boom(pos, Globals.SoundType.BLOCK)
		return true

	return false


# ตรวจสอบว่า กระสุน ชนกับสิ่งกีดขวางหรือไม่?
func hit_obstacle(unit: Vector2) -> bool:
	var cell = $TileMap.get_cell(unit.x, unit.y)
	if cell == Globals.BlockType.STEEL:
		return true
	elif cell == Globals.BlockType.BRICK:
		$TileMap.set_cell(unit.x, unit.y, TileMap.INVALID_CELL)
		return true
	return false


# แสดง effect ระเบิด
func boom(pos: Vector2, fx: int) -> void:
	var sfx = preload("res://FxBoom.tscn").instance()
	add_child(sfx)
	sfx.init(pos, fx)
	#print("boom at %s" % pos)

