extends Control

# Sử dụng preload để chắc chắn game_scn đã được gán đúng
@export var game_scn: PackedScene

func _ready() -> void:
	SolanaService.wallet.connect("on_login_finish", load_game)

func _on_pressed() -> void:
	SolanaService.wallet.try_login()

func load_game(success: bool) -> void:
	if success:
		get_tree().change_scene_to_packed(game_scn)
