extends Node2D

onready var gridContainer = $GridContainer
onready var leftButton = $LeftButton
onready var rightButton = $RightButton
onready var characterLabel = $CharacterLabel
onready var definitionLabel = $DefinitionLabel
onready var progressLabel = $Progress
onready var pageNumberLabel = $PageNumber

const kanjiLetter = preload("res://scenes/KanjiLetterOnList.tscn")
const CharacterEntry = preload("res://scripts/CharacterEntry.gd")
var index : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	#Kanji.addRandomToLearnt()
	setUpUI()

func setUpUI():
	setUpButtons()
	setUpLetters()
	
func setUpButtons():
	var maxPoss : int = (Kanji.characterArray.size() - 1)/100
	leftButton.disabled = index == 0
	rightButton.disabled = index == maxPoss
	pageNumberLabel.text = str(index + 1) + "/" + str(maxPoss + 1)

func setUpLetters():
	for n in gridContainer.get_children():
		gridContainer.remove_child(n)
		n.queue_free()
	
	
	for i in range(index*100,(index + 1)*100):#Kanji.characterArray.size()):
		var newLetter= kanjiLetter.instance()
		var newKanjiLetter : CharacterEntry = null
		if Kanji.characterArray.size() > i:
			newKanjiLetter = Kanji.characterArray[i]
		newLetter.adjustpath()
		newLetter.addCharacter(newKanjiLetter)
		gridContainer.add_child(newLetter)
		newLetter.connect("buttonPressedSignal",self, "newCharacterSelected")


func _on_LeftButton_button_down():
	index -= 1
	setUpUI()

func newCharacterSelected(value:CharacterEntry):
	characterLabel.text =  value.headCharacter
	match value.boxNum:
		1:
			progressLabel.text = "only just began learning."
		2: 
			progressLabel.text = "Remembered after a few days"
		3: 
			progressLabel.text = "Remembered several days"
		4: 
			progressLabel.text = "Remembered after a week"
		5:
			progressLabel.text = "Remembered after several weeks"
		6:
			progressLabel.text = "Remembered after one or more months"
		7:
			progressLabel.text = "Remembered after a quarter of a year"
		8:
			progressLabel.text = "Remembered after half a year"
	definitionLabel.text = value.meanings_list().replace("       ", "\n")

func _on_RightButton_button_down():
	index += 1
	setUpUI()


func _on_ReturnButton_button_down():
	get_tree().change_scene("res://HomeScreen.tscn")
