class_name SceneLoadFailedDialog
extends AcceptDialog

var path: String = ""
var fail_reason: ResourceLoader.ThreadLoadStatus


func _ready() -> void:
	dialog_text = dialog_text%path 

	match fail_reason:
		ResourceLoader.ThreadLoadStatus.THREAD_LOAD_FAILED:
			dialog_text += " An error occured while loading the scene resource."
		ResourceLoader.ThreadLoadStatus.THREAD_LOAD_INVALID_RESOURCE:
			dialog_text += " The specified scene resource is invalid."

	confirmed.connect(get_tree().quit)
	close_requested.connect(get_tree().quit)

	popup()
