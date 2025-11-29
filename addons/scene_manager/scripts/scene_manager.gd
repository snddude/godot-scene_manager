extends CanvasLayer

signal started_loading_scene
signal finished_loading_scene
signal changed_scene

enum TransitionType {}

const TRANSITION_TYPE_NONE: TransitionType = 0
const TRANSITION_TYPE_FADE_IN: TransitionType = 1
const TRANSITION_TYPE_FADE_OUT: TransitionType = 2
const TRANSITION_TYPE_FADE_IN_OUT: TransitionType = 3
const LOADING_SCREEN_SCENE: PackedScene = preload(
		"res://addons/scene_manager/resources/scenes/loading_screen.tscn")

var _loading_scene: bool = false


func load_scene(
		path_to_scene: String,
		transition_type: TransitionType,
		show_spinner: bool = true,
		show_progress_bar: bool = false) -> void:
	if _loading_scene:
		return

	_loading_scene = true
	started_loading_scene.emit()

	var instance: LoadingScreen = LOADING_SCREEN_SCENE.instantiate()

	instance.show_spinner = show_spinner
	instance.show_progress_bar = show_progress_bar
	instance.fade_in = (transition_type in [TRANSITION_TYPE_FADE_IN, TRANSITION_TYPE_FADE_IN_OUT])
	instance.fade_out = (transition_type in [TRANSITION_TYPE_FADE_OUT, TRANSITION_TYPE_FADE_IN_OUT])
	instance.path = path_to_scene

	instance.load_finished.connect(_change_scene)

	add_child(instance)

	if instance.fade_in:
		await instance.faded_in

	await get_tree().process_frame # Wait for end of current frame.
	get_tree().unload_current_scene()


func _change_scene(path_to_scene: String) -> void:
	var new_scene: PackedScene = ResourceLoader.load_threaded_get(path_to_scene)
	get_tree().change_scene_to_packed(new_scene)

	_loading_scene = false
	finished_loading_scene.emit()

	await get_tree().root.child_entered_tree # Wait until new scene enters tree.
	changed_scene.emit()
