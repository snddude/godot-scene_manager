# Scene Manager

A scene manager autoload with a loading screen that has fade in/out transitions.

## Installation

Download the [latest release](https://github.com/snddude/godot-scene_manager/releases/latest) of this plugin, which comes in a zip archive. Extract it into your project's "addons/" folder, then go to Project → Project Settings → Plugins and enable "Scene Manager".

## Usage

The way you transition to a different scene is as follows:

```gdscript
SceneManager.load_scene(
        path_to_scene: String,           # Path to the scene you want to transition to (e.g. res://resources/scenes/...).
        transition_type: TranstionType,       # The type of transition displayed when showing/hiding the loading screen.
        show_spinner: bool = true,       # Should the spinner be visible on the loading screen, set to true by default.
        show_progress_bar: bool = false  # Should the progress bar be visible on the loading screen, set to false by default.
)
```

The "transition_type" argument can have one of the following values:
- SceneManager.TRANSITION_TYPE_NONE - no transition;
- SceneManager.TRANSITION_TYPE_FADE_IN - the loading screen fades in when being showed;
- SceneManager.TRANSITION_TYPE_FADE_OUT - the loading screen fades out when being hidden;
- SceneManager.TRANSITION_TYPE_FADE_IN_OUT - the loading screen fades in when being showed and fades out when being hidden.

## License

[MIT](https://en.wikipedia.org/wiki/MIT_License)
