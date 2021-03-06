extends Node

# ขนาดฉากต่อสู้
const AREA_LEFT = 0
const AREA_RIGHT = 600
const AREA_UP = 0
const AREA_DOWN = 400

# ขนาดบล๊อก
const BLOCK_WIDTH = 64
const BLOCK_HEIGHT = 64

# ขนาดรถถัง
const TANK_WIDTH = 64
const TANK_HEIGHT = 64
const TANK_WIDTH_HALF = (TANK_WIDTH / 2)
const TANK_HEIGHT_HALF = (TANK_HEIGHT / 2)

# ขนาดกระสุน
const BULLET_WIDTH = 8
const BULLET_HEIGHT = 8
const BULLET_WIDTH_HALF = (BULLET_WIDTH / 2)
const BULLET_HEIGHT_HALF = (BULLET_HEIGHT / 2)

# ทิศทาง
const DIRECTION_LEFT = 0
const DIRECTION_RIGHT = 1
const DIRECTION_UP = 2
const DIRECTION_DOWN = 3

# แปลงค่า block ไปเป็น pixel
func block_to_pixel(block):
	assert(block is Vector2);
	return Vector2(block.x * BLOCK_WIDTH, block.y * BLOCK_HEIGHT)

# แปลงค่า pixel ไปเป็น block
func pixel_to_block(pixel):
	assert(pixel is Vector2);
	return Vector2(pixel.x / BLOCK_WIDTH, pixel.y / BLOCK_HEIGHT)

