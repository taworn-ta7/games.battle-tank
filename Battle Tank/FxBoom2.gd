extends Node2D


# จำนวนรอบ สำหรับทำ animate
var max_loop = 4
var loop = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


# ถูกเรียกเมื่อ AnimatedSprite เล่นจบ animate
func _on_Sprite_animation_finished():
	loop = loop + 1
	if loop < max_loop:
		$Sprite.frame = 0
	else:
		destroy()


# กำหนดค่าเริ่มต้น สำหรับ effect ระเบิด
func init(pos: Vector2) -> void:
	position = pos
	$Sprite.playing = true
	$BombAudio.playing = true


# ลบ scene นี้ออก
func destroy() -> void:
	get_parent().remove_child(self)
	queue_free()

