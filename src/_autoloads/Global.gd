extends Node


# Version
const GAME_VERSION = 0.1
const CONFIG_VERSION = 1 # Used for config migration
# Debug Options
const DEBUG = false


var debugLabel: Label
var current_level: int = -1
var ink_count: int = 0
var matches_count: int = 0
var time: float = 0
var lifes: int = 0

var userConfig = {
	"configVersion": CONFIG_VERSION,
	"highscore": 0,
	"soundVolume": 8,
	"musicVolume": 8,
	"unlocked_level": 0,
	"fullscreen": false,
	"brightness": 1.0,
	"contrast": 1.0,
	"resolution": {"w": 1280, "h": 720},
	"language": "en",
	"moving_bg": true,
	"glitch": true,
	"glow": true,
}

const levels = [
	"res://src/levels/Level0.tscn",
]
