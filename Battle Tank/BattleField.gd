extends Area2D


# เก็บค่า parent ไว้ เพื่อการ access บ่อยๆ
var parent


# Called when the node enters the scene tree for the first time.
func _ready():
	parent = get_parent()


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

	# ทดสอบรถถัง ที่ไม่ใช่ฝ่ายเดียวกัน
	var rect = Rect2(pos.x - Globals.AMMO_WIDTH_HALF, pos.y - Globals.AMMO_HEIGHT_HALF, Globals.AMMO_WIDTH, Globals.AMMO_HEIGHT)
	if fac == Globals.FactionType.ENEMY:
		# กระสุนฝ่ายศัตรู
		var tank = $HeroTank
		if tank != null && hit_tank(tank, rect):
			# ยิงโดน
			boom(pos, Globals.SoundType.BLOCK)
			if tank.get_hit():
				# พระเอกตาย T_T
				boom2(pos)
				parent.loss()
			return true
	elif fac == Globals.FactionType.HERO:
		# กระสุนพระเอก
		var count = get_child_count()
		var i = 0
		while i < count:
			var tank = get_child(i) as EnemyTank
			if tank != null && hit_tank(tank, rect):
				# ยิงโดน
				boom(pos, Globals.SoundType.BLOCK)
				if tank.get_hit():
					# ศัตรูตาย
					boom2(pos)
					# ศัตรูตายหมดแล้วหรือไม่?
					if check_winning():
						parent.win()
				return true
			i += 1

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


# ตรวจสอบว่า กระสุนโดนรถถัง
func hit_tank(tank: Tank, rect: Rect2) -> bool:
	var a = tank.get_area()
	return a.intersects(rect)


# ตรวจสอบว่า พระเอกชนะหรือยัง?
func check_winning() -> bool:
	var count = get_child_count()
	var i = 0
	while i < count:
		var tank = get_child(i) as EnemyTank
		if tank != null:
			return false
		i += 1
	return true


# แสดง effect ระเบิด
func boom(pos: Vector2, fx: int) -> void:
	var sfx = preload("res://FxBoom.tscn").instance()
	add_child(sfx)
	sfx.init(pos, fx)
	#print("boom at %s" % pos)


# แสดง effect ระเบิดใหญ่
func boom2(pos: Vector2) -> void:
	var sfx = preload("res://FxBoom2.tscn").instance()
	add_child(sfx)
	sfx.init(pos)
	#print("boom2 at %s" % pos)

