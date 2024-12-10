extends Control

# Đường dẫn đến scene tiếp theo
const CHAR_SELECTOR_SCENE := preload("res://scenes/ui/character_selector.tscn")

# Các button trong giao diện Dungeon
@onready var easy_button: Button = $Layer/Easy
@onready var normal_button: Button = $Layer/Normal
@onready var challenge_button: Button = $Layer/Challenge
@onready var hard_button: Button = $Layer/Hard
@onready var back_button: Button = $Layer/Backbutton

var char_selector_instance: Node = null  # Để quản lý scene tiếp theo (Character Selector)

func _ready() -> void:
	# Kết nối các nút với chức năng tương ứng
	easy_button.pressed.connect(self._on_easy_pressed)
	normal_button.pressed.connect(self._on_normal_pressed)
	challenge_button.pressed.connect(self._on_challenge_pressed)
	hard_button.pressed.connect(self._on_hard_pressed)
	back_button.pressed.connect(self._on_back_button_pressed)

func _on_easy_pressed() -> void:
	_change_to_character_selector()

func _on_normal_pressed() -> void:
	_change_to_character_selector()

func _on_challenge_pressed() -> void:
	_change_to_character_selector()

func _on_hard_pressed() -> void:
	_change_to_character_selector()

func _on_back_button_pressed() -> void:
	# Quay trở lại Main Menu
	if char_selector_instance:
		char_selector_instance.queue_free()
		char_selector_instance = null
	queue_free()  # Giải phóng Dungeon UI để quay lại Main Menu

func _change_to_character_selector() -> void:
	if char_selector_instance:
		char_selector_instance.queue_free()
		char_selector_instance = null
	
	char_selector_instance = CHAR_SELECTOR_SCENE.instantiate()
	get_tree().root.add_child(char_selector_instance)  # Thêm scene Character Selector
	queue_free()  # Giải phóng Dungeon UI
