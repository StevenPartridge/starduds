extends Control

@onready var rich_text_label = $ColorRect/RichTextLabel
var current_score: int = 0
var player: CharacterBody2D

func _ready():
	# Assuming the player node is in the scene and named "SpaceShip"
	player = get_node("../../SpaceShip")

func _process(_delta):
	# Check if the player node exists and has the 'get_power' method
	if player and player.has_method("get_power"):
		current_score = player.get_power()

		rich_text_label.text = str(current_score)
