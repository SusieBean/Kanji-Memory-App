extends Node2D

onready var instruction = $UI/Instruction
onready var character = $UI/Character
onready var meaning = $UI/Meanings
onready var reveal = $UI/Reveal
onready var correct = $UI/IsCorrect/Correct
onready var wrong = $UI/IsCorrect/Wrong
onready var isNew = $UI/IsNew
onready var pronunciations = $UI/Pronunciations
onready var examples = $UI/Examples
onready var alternateReading = $UI/AlternateReadingsLetter
onready var lookalikeLetters = $UI/LookAlikeCharactersList

const CharacterEntry = preload("res://scripts/CharacterEntry.gd")
const Date = preload("res://scripts/RevisionDate.gd")


var arraySize : int = 1
var currentCharacter : CharacterEntry
var currentIndex : int = 0

var isCharacter : bool = false
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	Boxes.putInOrder()
	arraySize = Boxes.currentCharactersToRevise.size()
	refresh()



func refresh():
	Kanji.saveToDictionary()
	reveal.disabled = false
	correct.disabled = true
	wrong.disabled = true
	
	#if character
	#else say revision is complete for today or something???
	if (Boxes.currentCharactersToRevise.size() > 0):
		currentCharacter = Boxes.currentCharactersToRevise[0]
		displayCharacter()
	else:
		currentCharacter = null
		displayNone()
		reveal.disabled = true



func displayCharacter():
	isCharacter = int(rng.randi_range(0,1)) == 0
	instruction.text = "WRITE DOWN ALL MEANINGS (" + str(currentCharacter.numOfMeanings()) + ")" if isCharacter else "WRITE DOWN THE CHARACTER"
	character.text = currentCharacter.headCharacter if isCharacter else ""
	meaning.text = currentCharacter.meanings_list() if !isCharacter else ""
	isNew.text = "NEW" if currentCharacter.dateForNextStudy.isPastCurrentDate() == 1 else ""
	pronunciations.text = ""
	examples.text = ""
	alternateReading.text = ""
	lookalikeLetters.text = ""
	
func reveal():
	character.text = currentCharacter.headCharacter
	meaning.text = currentCharacter.meanings_list()
	pronunciations.text = currentCharacter.readings_list()
	examples.text = currentCharacter.examples_list()
	lookalikeLetters.text = currentCharacter.lookalike_list()
	
	alternateReading.text = currentCharacter.nonStandardForm if currentCharacter.nonStandardForm != null else ""
	
func displayNone():
	instruction.text = "NONE LEFT TO REVISE TODAY"
	character.text = "?"
	meaning.text = "?????"
	isNew.text = ""
	pronunciations.text = "????"
	examples.text = "????"
	alternateReading.text = "?"
	lookalikeLetters.text = "???"

func _on_ReturnButton_button_down():
	get_tree().change_scene("res://scenes/HomeScreen.tscn")


func _on_Reveal_button_down():
	reveal()
	reveal.disabled = true
	correct.disabled = false
	wrong.disabled = false


func _on_Correct_button_down():
	Boxes.moveCorrectToNext()
	refresh()


func _on_Wrong_button_down():
	Boxes.resetCharacter()
	refresh()
