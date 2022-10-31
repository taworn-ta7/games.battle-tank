extends Node


# ขนาด 1 unit == 8x8 pixels
const UNIT_WIDTH = 8
const UNIT_HEIGHT = 8
const UNIT_WIDTH_HALF = (UNIT_WIDTH / 2)
const UNIT_HEIGHT_HALF = (UNIT_HEIGHT / 2)

# ขนาดรถถัง 1 คัน == 16x16 pixels (2x2 เท่าของ unit)
const TANK_WIDTH = 16
const TANK_HEIGHT = 16
const TANK_WIDTH_HALF = (TANK_WIDTH / 2)
const TANK_HEIGHT_HALF = (TANK_HEIGHT / 2)

# ขนาดกระสุน
const AMMO_WIDTH = 8
const AMMO_HEIGHT = 8
const AMMO_WIDTH_HALF = (AMMO_WIDTH / 2)
const AMMO_HEIGHT_HALF = (AMMO_HEIGHT / 2)

# ขนาดฉากต่อสู้, เป็น pixels (อย่าลืม ค่าที่นี่ต้อง x4, หน่วยเป็น unit)
const AREA_LEFT = 0
const AREA_RIGHT = 256 # หาร 16 เพื่อเป็นตำแหน่ง max คือ 16
const AREA_UP = 0
const AREA_DOWN = 144 # หาร 16 เพื่อเป็นตำแหน่ง max คือ 9

# สิ่งกีดขวางการเดิน
enum BlockType {
	NONE = -1,
	STEEL = 0,
	BRICK = 1,
	WATER = 2,
}

# เสียง
enum SoundType {
	NONE = -1,
	WALL = 0,
	BLOCK = 1,
}

# ทิศทาง
enum DirectionType {
	NONE = -1,
	LEFT = 0,
	RIGHT = 1,
	UP = 2,
	DOWN = 3,
}

# ฝ่าย
enum FactionType {
	NONE = -1,
	ENEMY = 0,
	HERO = 1,
}

# รถถังให้เลือก
enum TankType {
	YELLOW_FAST_0   = (0 + 125),
	YELLOW_NORMAL_0 = (0 + 0),
	YELLOW_NORMAL_1 = (0 + 100),
	YELLOW_NORMAL_2 = (0 + 150),
	YELLOW_MEDIUM_0 = (0 + 25),
	YELLOW_MEDIUM_1 = (0 + 50),
	YELLOW_LARGE_0  = (0 + 75),
	YELLOW_LARGE_1  = (0 + 175),
	GREEN_FAST_0    = (0 + 325),
	GREEN_NORMAL_0  = (0 + 200),
	GREEN_NORMAL_1  = (0 + 300),
	GREEN_NORMAL_2  = (0 + 350),
	GREEN_MEDIUM_0  = (0 + 225),
	GREEN_MEDIUM_1  = (0 + 250),
	GREEN_LARGE_0   = (0 + 275),
	GREEN_LARGE_1   = (0 + 375),
	WHITE_FAST_0    = (8 + 125),
	WHITE_NORMAL_0  = (8 + 0),
	WHITE_NORMAL_1  = (8 + 100),
	WHITE_NORMAL_2  = (8 + 150),
	WHITE_MEDIUM_0  = (8 + 25),
	WHITE_MEDIUM_1  = (8 + 50),
	WHITE_LARGE_0   = (8 + 75),
	WHITE_LARGE_1   = (8 + 175),
	PURPLE_FAST_0   = (8 + 325),
	PURPLE_NORMAL_0 = (8 + 200),
	PURPLE_NORMAL_1 = (8 + 300),
	PURPLE_NORMAL_2 = (8 + 350),
	PURPLE_MEDIUM_0 = (8 + 225),
	PURPLE_MEDIUM_1 = (8 + 250),
	PURPLE_LARGE_0  = (8 + 275),
	PURPLE_LARGE_1  = (8 + 375),
}


# แปลงค่า pixel ไปเป็น unit
func pixel_to_unit(pixel: Vector2) -> Vector2:
	var x = int(pixel.x / UNIT_WIDTH)
	var y = int(pixel.y / UNIT_HEIGHT)
	return Vector2(x, y)

