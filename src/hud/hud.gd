extends Control


func _ready() -> void:
	Events.connect("hud_lifes", _lifes)
	Events.connect("hud_matches", _matches)
	Events.connect("hud_ink", _ink)
	Events.connect("hud_time", _time)


func _matches(count):
	$Match.set_text("Matches: " + str(count))

func _ink(count):
	$Ink/TextureProgressBar.value = count

func _time(count):
	$Time.set_text("¦ " + str("%.2f" % count))

func format_time(milliseconds: int) -> String:
	var minutes = (milliseconds / 60000) as int
	var seconds = ((milliseconds % 60000) / 1000) as int
	var millis = milliseconds % 1000
	return "%02d:%02d:%03d" % [minutes, seconds, millis]


func _lifes(count):
	match count:
		5:
			$Lifes.set_text("_____")
		4:
			$Lifes.set_text("____^")
		3:
			$Lifes.set_text("___^^")
		2:
			$Lifes.set_text("__^^^")
		1:
			$Lifes.set_text("_^^^^")
		_:
			$Lifes.set_text("^^^^^")
