class_name CardVisuals
extends Control

@export var card: Card : set = set_card

@onready var panel: Panel = $Panel
@onready var icon: TextureRect = $Icon


func set_card(value: Card) -> void:
	if not is_node_ready():
		await ready

	card = value
	icon.texture = card.icon
