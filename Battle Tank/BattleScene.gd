extends Node2D


# กำลังเล่น แพ้ ชนะ
enum PlayType {
	NONE,
	START,
	PLAYING,
	LOSS,
	WIN,
	NEXT,
}
var play = PlayType.NONE

# หน่วงเวลา
var time = 0

# รายชื่อฉาก
var area_list = [
	#"res://BattleField.tscn",
	"res://Area1BattleField.tscn",
	"res://Area2BattleField.tscn",
	"res://Area3BattleField.tscn",
]

# ฉากปัจจุบัน
var area = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if play == PlayType.NONE:
		# ยังไม่มีอะไร แสดงฉาก
		$DisplayLabel.visible = true
		$DisplayLabel.text = "AREA %s" % (area + 1)
		# unload BattleField ตัวเก่า
		remove_child(get_node('BattleField'))
		# สร้าง field ใหม่่จาก area_list
		var field = load(area_list[area]).instance()
		# สร้าง node ใหม่ และ add เข้าไปใน BattleScene เหมือนที่เราทำมือ
		add_child(field)
		# ขยับ field ไปอยู่ตำแหน่งแรกสุด
		move_child(field, 0)
		time = 0
		play = PlayType.START
	elif play == PlayType.START:
		# หน่วงเวลา
		time += delta
		if time >= 2:
			$DisplayLabel.visible = false
			play = PlayType.PLAYING
	elif play == PlayType.LOSS:
		# แพ้ :(
		if Input.is_action_pressed("ui_accept"):
			get_tree().change_scene("res://TitleScene.tscn")
	elif play == PlayType.WIN:
		# ชนะ :)
		if Input.is_action_pressed("ui_accept"):
			play = PlayType.NEXT
	elif play == PlayType.NEXT:
		area += 1
		if area < area_list.size():
			play = PlayType.NONE
		else:
			get_tree().change_scene("res://EndScene.tscn")


# กำลังเล่นอยู่หรือไม่?
func playing() -> bool:
	return play == PlayType.PLAYING


# แจ้งสถานะ พระเอกตาย
func loss() -> void:
	play = PlayType.LOSS
	$DisplayLabel.visible = true
	$DisplayLabel.text = "GAME OVER"


# แจ้งสถานะ พระเอกชนะ
func win() -> void:
	play = PlayType.WIN
	$DisplayLabel.visible = true
	$DisplayLabel.text = "YOU WIN"

