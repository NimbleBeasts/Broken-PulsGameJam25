extends Control

var state = Types.GameStates.Menu
var levelNode = null


func _ready():
	# Set Viewport Sizes to Project Settings
	$gameViewport/SubViewport.size = Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"), ProjectSettings.get_setting("display/window/size/viewport_height"))
	$menuViewport/SubViewport.size = Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"), ProjectSettings.get_setting("display/window/size/viewport_height"))

	Global.debugLabel = $Debug

	# Event Hooks
	#Events.connect("new_game", Callable(self, "_newGame"))
	Events.connect("load_level", Callable(self, "_loadLevel"))
	
	Events.connect("game_end",_backToMenu)
	Events.connect("game_restart", _game_restart)
	Events.connect("game_nextlevel", _game_next)


	switchTo(Types.GameStates.Menu)

	#print(Global.userConfig.glitch)

# State Transition Function
func switchTo(to):
	if to == Types.GameStates.Menu:
		$gameViewport.hide()
		$menuViewport.show()
		$menuViewport/SubViewport/Menu.show()
	elif to == Types.GameStates.Game:
		$gameViewport.show()
		$menuViewport.hide()
		$menuViewport/SubViewport/Menu.hide()
	state = to

# Load a level to the LevelHolder node
func loadLevel(number = 0):
	Global.current_level = number
	levelNode = load(Global.levels[number]).instantiate()
	$gameViewport.get_node("SubViewport/LevelHolder").add_child(levelNode)

# Unloads a loaded level
func unloadLevel():
	$gameViewport.get_node("SubViewport/LevelHolder").remove_child(levelNode)
	if levelNode:
		levelNode.queue_free()
	levelNode = null

func reloadLevel():
	unloadLevel()
	loadLevel(Global.current_level)
	get_tree().paused = false

###############################################################################
# Callbacks
###############################################################################

func _shader_toggle(state):
	var world = $gameViewport/SubViewport/WorldEnvironment.environment
	if state:
		world.glow_enabled = true
	else:
		world.glow_enabled = false

	$gameViewport/SubViewport/WorldEnvironment.environment = world
	#$menuViewport/Viewport/WorldEnvironment.environment = world

# Event Hook: Back from Game to Menu
func _backToMenu():
	unloadLevel()
	switchTo(Types.GameStates.Menu)

# Event Hook: New Game
func _newGame():
	#GameData.new_level()
	_game_restart()

func _loadLevel(id):
	#GameData.new_level()
	if levelNode:
		unloadLevel()
	loadLevel(id)
	switchTo(Types.GameStates.Game)

func _game_restart():
	if levelNode:
		unloadLevel()
	loadLevel(Global.current_level)
	switchTo(Types.GameStates.Game)

func _game_next():
	Global.current_level += 1
	_loadLevel(Global.current_level)

# Event Hook: Update user config for sound
func setSoundVolume(value):
	Global.userConfig.soundVolume = value
	Global.saveConfig()

# Event Hook: Update user config for music
func setMusicVolume(value):
	Global.userConfig.musicVolume = value
	Global.saveConfig()

func setBrightness(value):
	$gameViewport/SubViewport/WorldEnvironment.environment.adjustment_brightness = value
	Global.userConfig.brightness = value
	Global.saveConfig()

func setContrast(value):
	$gameViewport/SubViewport/WorldEnvironment.environment.adjustment_contrast = value
	Global.userConfig.contrast = value
	Global.saveConfig()
# Event Hook: Switch to fullscreen mode and update user config
func _switchFullscreen(value):
	Global.setFullscreen(value)
