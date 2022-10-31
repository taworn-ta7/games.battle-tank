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

