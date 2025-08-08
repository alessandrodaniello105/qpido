class_name MinigameCore
extends Node2D

func _ready():
	print("🌀 MinigameCore (2D + UI) pronto")

func exit_minigame():
	print("🔚 Esci dal minigioco")
	get_tree().change_scene_to_file("res://scenes/MainScene.tscn")
