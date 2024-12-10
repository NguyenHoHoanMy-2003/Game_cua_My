extends Control

# Tham chiếu các node
@onready var exp_label: Label = $text/EXP
@onready var gold_label: Label = $text/Gold
@onready var char1: TextureButton = $char/Char1
@onready var char2: TextureButton = $char/Char2
@onready var char3: TextureButton = $char/Char3
@onready var area1: Area2D = $o/area2d_1  # Thay CollisionShape2D thành Area2D
@onready var area2: Area2D = $o/area2d_2
@onready var area3: Area2D = $o/area2d_3
@onready var rock: TextureRect = $o/rock
@onready var submit_button: Button = $button/Submit
@onready var haigio_button: Button = $button/haigio
@onready var bongio_button: Button = $button/bongio
@onready var saugio_button: Button = $button/saugio

# Lưu EXP và Gold dựa trên thời gian
var current_exp: int = 0
var current_gold: int = 0

var total_seconds : int = 0
var selected_time : int = 0
func _ready() -> void:
	# Kết nối sự kiện thời gian
	haigio_button.pressed.connect(self._on_haigio_pressed)
	bongio_button.pressed.connect(self._on_bongio_pressed)
	saugio_button.pressed.connect(self._on_saugio_pressed)

	# Kết nối sự kiện cho từng nhân vật
	char1.gui_input.connect(self._on_char1_pressed)
	char2.gui_input.connect(self._on_char2_pressed)
	char3.gui_input.connect(self._on_char3_pressed)

	# Kết nối sự kiện cho nút Submit
	submit_button.pressed.connect(self._on_submit_pressed)

# Phần 1: Cập nhật EXP và Gold khi nhấn nút thời gian
func _on_haigio_pressed() -> void:
	selected_time = 2
	update_exp_gold(2)

func _on_bongio_pressed() -> void:
	selected_time = 4
	update_exp_gold(4)

func _on_saugio_pressed() -> void:
	selected_time = 6
	update_exp_gold(6)

func update_exp_gold(hours: int) -> void:
	current_exp = hours * 50  # Mỗi giờ nhận được 50 EXP
	current_gold = hours * 10  # Mỗi giờ nhận được 10 Gold
	exp_label.text = "EXP: " + str(current_exp)
	gold_label.text = "Gold: " + str(current_gold)

# Phần 2: Xử lý sự kiện TextureButton cho từng nhân vật
func _on_char1_pressed(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		place_character(char1)

func _on_char2_pressed(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		place_character(char2)

func _on_char3_pressed(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		place_character(char3)

func place_character(character_button: TextureButton) -> void:
	# Kiểm tra xem các slot có nhân vật chưa bằng cách kiểm tra node con của Area2D
	if area1.get_child_count() <= 1:
		move_to_slot(character_button, area1)
	elif area2.get_child_count() <=1:
		move_to_slot(character_button, area2)
	elif area3.get_child_count() <= 1:
		move_to_slot(character_button, area3)

# Di chuyển nhân vật vào slot
func move_to_slot(character_button: TextureButton, slot: Area2D) -> void:
	var character_instance = character_button.duplicate()  # Tạo bản sao của nhân vật
	slot.add_child(character_instance)  # Thêm nhân vật vào slot
	character_instance.position = Vector2(0,0)
	
	var time_label = Label.new()
	slot.add_child(time_label)
	time_label.text = ""
	time_label.position = character_instance.position + Vector2(0, character_instance.size.y + 10)
	time_label.name = "TimeLabel"
	character_button.queue_free()  # Xóa nhân vật ở khu vực ban đầu

# Phần 3: Kích hoạt hiệu ứng khi nhấn Submit
func _on_submit_pressed() -> void:
	if selected_time > 0:
		activate_rock_effect(selected_time)
		for slot in [area1, area2, area3]:
			if slot.get_child_count() > 1:
				var time_label = slot.get_node_or_null("TimeLabel")
				if time_label:
					start_countdown(time_label, selected_time)

func start_countdown(time_label: Label, time_in_hours: int) -> void:
	total_seconds = time_in_hours * 3600  # Chuyển đổi giờ thành giây
	
	# Tạo Timer để thực hiện đếm ngược
	var countdown_timer = Timer.new()
	countdown_timer.wait_time = 1.0  # Mỗi giây giảm 1 lần
	countdown_timer.one_shot = false
	add_child(countdown_timer)
	countdown_timer.start()

	# Kết nối Timer với logic đếm ngược
	countdown_timer.timeout.connect(func() -> void:
		_update_countdown(time_label, countdown_timer)
	)

func _update_countdown(time_label: Label, countdown_timer: Timer) -> void:
	if total_seconds > 0:
		total_seconds -= 1
		var hours = int(total_seconds / 3600)
		var minutes = int((total_seconds % 3600) / 60)
		var seconds = int(total_seconds % 60)
		time_label.text = "%02d:%02d:%02d" % [hours, minutes, seconds]
	else:
		countdown_timer.stop()
		countdown_timer.queue_free()
		time_label.text = "Hoàn tất!"

func activate_rock_effect(time_in_hours: int) -> void:
	if rock == null:
		push_error("Error: 'rock' node is null. Please check if the node is assigned correctly.")
		return
	
	var total_seconds = time_in_hours * 3600  # Tổng số giây cần chạy hiệu ứng
	var elapsed_time = 0  # Thời gian đã trôi qua
	
	while elapsed_time < total_seconds:
		# Tạo Tween mới
		var tween = create_tween()
		
		# Thu nhỏ rock
		tween.tween_property(rock, "scale", Vector2(0.15, 0.15), 0.5)  # Thu nhỏ trong 0.5 giây
		tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		
		# Chờ hiệu ứng thu nhỏ hoàn tất
		await tween.finished
		
		# Phóng to rock
		tween = create_tween()  # Tạo Tween mới
		tween.tween_property(rock, "scale", Vector2(0.3, 0.3), 0.5)  # Phóng to trong 0.5 giây
		tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		
		# Chờ hiệu ứng phóng to hoàn tất
		await tween.finished
		
		# Tăng thời gian đã trôi qua
		elapsed_time += 1  # Mỗi vòng lặp tương ứng với 1 giây
