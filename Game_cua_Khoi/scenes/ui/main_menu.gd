extends Control

# Đảm bảo đường dẫn đến Shop UI chính xác
const SHOP_UI := preload("res://scenes/ui/a_shop_main_menu.tscn") 
const DUNGEON_MODE := preload("res://scenes/ui/b_dungeone.tscn")
const BACKPACK_UI := preload("res://scenes/ui/b_backpack.tscn")
const MINE_UI := preload("res://scenes/ui/a_mine.tscn")
@onready var shop_button: TextureButton = $Chest
@onready var dungeon_button : TextureButton = $Dungeongate
@onready var backpack_button : TextureButton = $bag
@onready var mine_button : TextureButton = $Minegate
# Cần một biến để lưu shop instance
var shop_instance: Node = null
var dungeon_instance : Node = null
var backpack_instance : Node = null
var mine_instance : Node = null
func _ready() -> void:
	# Kết nối nút với chức năng khi nhấn vào shop button
	shop_button.pressed.connect(self._on_shop_pressed)
	dungeon_button.pressed.connect(self._on_dungeon_pressed)
	backpack_button.pressed.connect(self._on_backpack_pressed)
	mine_button.pressed.connect(self._on_mine_pressed)
func _on_shop_pressed() -> void:
	# Nếu giao diện Shop đã mở, đóng lại và giải phóng tài nguyên
	if shop_instance:
		shop_instance.queue_free()
		shop_instance = null  # Đặt về null sau khi giải phóng
		self.visible = true  # Hiển thị lại Main Menu
	else:
		shop_instance = SHOP_UI.instantiate()
		# Kết nối tín hiệu từ nút Leave của giao diện Shop với hàm xử lý
		shop_instance.get_node("UILayer/Leave").pressed.connect(_on_shop_leave_pressed)
		get_tree().root.add_child(shop_instance)
		self.visible = false  # Ẩn Main Menu

func _on_shop_leave_pressed() -> void:
	# Đóng giao diện Shop và hiển thị lại Main Menu
	if shop_instance:
		shop_instance.queue_free()
		shop_instance = null
	self.visible = true

func _on_dungeon_pressed() -> void:
	if dungeon_instance:
		dungeon_instance.queue_free()
		dungeon_instance = null
		self.visible = true
	else:
		dungeon_instance = DUNGEON_MODE.instantiate()
		# Kết nối nút Backbutton với hàm xử lý
		dungeon_instance.get_node("Layer/Backbutton").pressed.connect(_on_dungeon_leave_pressed)
		get_tree().root.add_child(dungeon_instance)  # Thêm Dungeon vào cây scene
		self.visible = false
func _on_dungeon_leave_pressed() -> void :
	if dungeon_instance:
		dungeon_instance.queue_free()
		dungeon_instance = null
	self.visible = true

func _on_backpack_pressed() -> void:
	# Nếu giao diện Shop đã mở, đóng lại và giải phóng tài nguyên
	if backpack_instance:
		backpack_instance.queue_free()
		backpack_instance = null  # Đặt về null sau khi giải phóng
		self.visible = true  # Hiển thị lại Main Menu
	else:
		backpack_instance = BACKPACK_UI.instantiate()
		# Kết nối tín hiệu từ nút Leave của giao diện Shop với hàm xử lý
		backpack_instance.get_node("BackLayer/Leave").pressed.connect(_on_backpack_pressed)
		get_tree().root.add_child(backpack_instance)
		self.visible = false  # Ẩn Main Menu
func _on_backpack_leave_pressed() -> void:
	if backpack_instance:
		backpack_instance.queue_free()
		backpack_instance = null
	self.visible = true
func _on_mine_pressed() -> void:
	# Nếu giao diện Shop đã mở, đóng lại và giải phóng tài nguyên
	if mine_instance:
		mine_instance.queue_free()
		mine_instance = null  # Đặt về null sau khi giải phóng
		self.visible = true  # Hiển thị lại Main Menu
	else:
		mine_instance = MINE_UI.instantiate()
		# Kết nối tín hiệu từ nút Leave của giao diện Shop với hàm xử lý
		mine_instance.get_node("BackLayer/return").pressed.connect(_on_mine_pressed)
		get_tree().root.add_child(mine_instance)
		self.visible = false  # Ẩn Main Menu
func _on_mine_leave_pressed() -> void:
	if mine_instance:
		mine_instance.queue_free()
		mine_instance = null
	self.visible = true
