extends Panel

onready var button = self.get_node("Button")
onready var characterLabel = self.get_node("Button/Character")

export var character = "学"

const CharacterEntry = preload("res://scripts/CharacterEntry.gd")
var thisCharacter : CharacterEntry 

var rng = RandomNumberGenerator.new()
var displayColour : Color
export var defaultColour : Color
export var  dailyLearn : Color
export var otherDailyLearn : Color
export var weeklyLearn : Color
export var biweeklyLearn : Color
export var monthlyLearn : Color
export var quarterYearlyLearn : Color
export var halfYearlyLearn : Color
export var yearlyLearn : Color

signal buttonPressedSignal
	
func adjustpath():
	button = self.get_node("Button")
	characterLabel = self.get_node("Button/Character")

func addCharacter( var newChar : CharacterEntry = null):
	button.disabled = newChar == null || !newChar.addedToLearning
	thisCharacter = newChar
	character = (newChar.headCharacter if newChar.addedToLearning else "?") if newChar!=null else "-"
	if (newChar != null):
		match newChar.boxNum:
			1:
				displayColour = dailyLearn
			2: 
				displayColour = otherDailyLearn
			3: 
				displayColour = weeklyLearn
			4: 
				displayColour = biweeklyLearn
			5: 
				displayColour = monthlyLearn
			6:
				displayColour = quarterYearlyLearn
			7:
				displayColour = halfYearlyLearn
			8: 
				displayColour = yearlyLearn

			
	updateDisplay()

func yayItWorked():
	print("Yay!")

func _on_Button_button_down():
	emit_signal("buttonPressedSignal",thisCharacter)
	
func updateDisplay():
	characterLabel.text = character
	if thisCharacter != null:
		characterLabel.set("custom_colors/font_color",  displayColour)
