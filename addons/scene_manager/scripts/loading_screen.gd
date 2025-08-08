class_name LoadingScreen
extends Control

signal faded_in
signal faded_out
signal load_finished(path_to_scene: String)

const LOAD_FAILED_DIALOG: PackedScene = preload(
		"res://addons/scene_manager/resources/scenes/load_failed_dialog.tscn")

@export_range(0.0, 0.5, 0.01) var _fade_in_time: float
@export_range(0.0, 0.5, 0.01) var _fade_out_time: float
@export var _wait_for_progress_bar: bool = false
@export_group("Nodes")
@export var _spinner: TextureRect
@export var _progress_bar: ProgressBar

var fade_in: bool = false
var fade_out: bool = false
var show_progress: bool = false
var path: String = ""
var _max_progress: float = 0.0
var _progress: Array[float] = []


func _ready() -> void:
	_max_progress = _progress_bar.max_value

	_spinner.visible = show_progress
	_progress_bar.visible = show_progress

	if fade_in:
		modulate.a = 0.0
		_fade_in()

	ResourceLoader.load_threaded_request(path)


func _process(delta: float) -> void:
	if not path:
		return

	var status: ResourceLoader.ThreadLoadStatus = ResourceLoader.load_threaded_get_status(path, 
			_progress)

	var rate: float = 1.0 - exp(-35.0 * delta)
	_progress_bar.value = move_toward(_progress_bar.value, _progress[0] * _max_progress, rate)

	match status:
		ResourceLoader.ThreadLoadStatus.THREAD_LOAD_FAILED:
			set_process(false)
			_display_load_failed_dialog(status)
		ResourceLoader.ThreadLoadStatus.THREAD_LOAD_INVALID_RESOURCE:
			set_process(false)
			_display_load_failed_dialog(status)
		ResourceLoader.THREAD_LOAD_LOADED:
			if (show_progress and _wait_for_progress_bar and _progress_bar.value != _max_progress):
				return

			set_process(false)

			_progress_bar.value = _max_progress
			create_tween().tween_property(_spinner, "modulate:a", 0.0, 0.25)

			# Wait for minimum ammount of time for loading screen to be visible
			await get_tree().create_timer(0.5).timeout
			load_finished.emit(path)

			if fade_out:
				_fade_out()
				await faded_out

			queue_free()


func _fade_in() -> void:
	var tween := create_tween()
	tween.finished.connect(faded_in.emit)

	tween.tween_property(self, "modulate:a", 1.0, _fade_in_time)


func _fade_out() -> void:
	var tween := create_tween()
	tween.finished.connect(faded_out.emit)

	tween.tween_property(self, "modulate:a", 0.0, _fade_out_time)


func _display_load_failed_dialog(fail_reason: ResourceLoader.ThreadLoadStatus) -> void:
	var instance: SceneLoadFailedDialog = LOAD_FAILED_DIALOG.instantiate()
	instance.path = path
	instance.fail_reason = fail_reason
	get_tree().root.add_child(instance)
