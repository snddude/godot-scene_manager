@tool
extends EditorPlugin


func _enter_tree() -> void:
	add_autoload_singleton("SceneManager", 
			"res://addons/scene_manager/resources/scenes/autoload/scene_manager.tscn")


func _exit_tree() -> void:
	remove_autoload_singleton("SceneManager")
