extends Control

func _on_leave_pressed() -> void:
	# Tìm node MainMenu để hiển thị lại
	var main_menu = get_tree().get_root().get_node("MainMenu")
	if main_menu:
		main_menu.visible = true
		queue_free()
