extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var characterLabel = $GUI/MainContainer/MainPanel/VBoxContainer/Panel/CharacterDisplay/BigName/Label
onready var titleLabel = $GUI/MainContainer/MainPanel/VBoxContainer/HBoxContainer/NamePanel/Title
onready var descriptionLabel = $GUI/MainContainer/MainPanel/VBoxContainer/DescriptionPanel/Description
onready var tween = $GUI/Tween
onready var pronunciations = $Pronunciations
onready var examples = $Examples
onready var alternateReading = $AlternateReadingsLetter
onready var lookalikeLetters = $LookAlikeCharactersList


var rng = RandomNumberGenerator.new()

var index = 0
onready var order : Array = []
onready var normalOrder : Array = []


var showKanji : bool = true
var showDefinition : bool = true

var difference : int = 1
var minNum : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	#rng.randomize()
	difference = FlashCardIndex.maxNum - FlashCardIndex.minNum
	normalOrder = range(difference)
	normalOrderCharacters()
#	randomlyOrderCharacters()
	set_display()

	

func randomlyOrderCharacters():
	var orderToGetFrom : Array = range(difference)
	order = []
	while orderToGetFrom.size() > 0:
		var randomIndex = rng.randi()%orderToGetFrom.size()
		order.append(orderToGetFrom[randomIndex])
		orderToGetFrom.remove(randomIndex)
	for character in order:
		print(character)

func normalOrderCharacters():
	order = normalOrder



func set_display():
	var currentChar = Kanji.characterArray[order[index] + FlashCardIndex.minNum]
	
	titleLabel.text = currentChar.meanings_list() if showDefinition else ""
	characterLabel.text = currentChar.headCharacter if showKanji else ""
	
	var descriptionText = currentChar.mneumonic if showDefinition && showKanji else ""
	descriptionLabel.text = descriptionText
	var descriptionFontSize = 30.0 - 0.03*descriptionText.length()
	if (descriptionFontSize < 0):
		 descriptionFontSize = 1
		
	descriptionLabel.get("custom_fonts/font").size =  descriptionFontSize
		
	var exampleText = currentChar.examples_list() if showDefinition && showKanji else ""
	var pronunciationText = currentChar.readings_list()  if showDefinition && showKanji else ""
	
	pronunciations.text = pronunciationText + "\n--\n" + exampleText  #currentChar.readings_list() if showDefinition && showKanji else ""
	
	
	var examplesFontSize = 26.0 - 0.03*exampleText.length() - 0.02*pronunciationText.length()
	
	print( examplesFontSize)
	
	#examples.text = exampleText
	if ( examplesFontSize < 0):
		 examplesFontSize = 1
	
	
	pronunciations.get("custom_fonts/font").size =  examplesFontSize
	
	
	lookalikeLetters.text = currentChar.lookalike_list() if showDefinition && showKanji else ""

	alternateReading.text = currentChar.nonStandardForm if currentChar.nonStandardForm != null && showDefinition && showKanji else ""
	


func _on_LeftClick_button_down():
	#print("Left pressed")
	index += difference - 1
	index %= difference
	set_display()


func _on_RightClick_button_down():
	#print("Right pressed")
	index += 1
	index %= difference
	set_display()


func _on_KanjiButton_button_down():
	print("kanji button down")
	showKanji = !showKanji
	showDefinition = showDefinition || !showKanji
	set_display()


func _on_DefinitionButton_button_down():
	print("definition button down")
	showDefinition = !showDefinition
	showKanji = showKanji || !showDefinition
	set_display()

func _on_ReturnButton_button_down():
	get_tree().change_scene("res://scenes/HomeScreen.tscn")

