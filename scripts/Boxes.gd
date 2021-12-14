extends Node

const CharacterEntry = preload("res://scripts/CharacterEntry.gd")
const Date = preload("res://scripts/RevisionDate.gd")

var currentCharactersToRevise : Array = []
var dateRegistered : Date = Date.new()

var notBeganRevision : Array = []
var dailyCharacters : Array = []
var otherDailyCharacters : Array = []
var weeklyCharacters : Array = []
var biweeklyCharacters : Array = []
var monthlyCharacters : Array = []
var quarterYearlyCharacters: Array = []
var halfYearlyCharacters : Array = []
var yearlyCharacters: Array = []

var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	dateRegistered = Date.new()
	dateRegistered.newDate()

func putInBoxes():
	for i in Kanji.characterArray:
		match i.boxNum:
			-1:
				notBeganRevision.append(i)
			1:
				dailyCharacters.append(i)
			2:
				otherDailyCharacters.append(i)
			3: 
				weeklyCharacters.append(i)
			4: 
				biweeklyCharacters.append(i)
			5: 
				monthlyCharacters.append(i)
			6:
				quarterYearlyCharacters.append(i)
			7:
				halfYearlyCharacters.append(i)
			8:
				yearlyCharacters.append(i)
			_:
				printerr("This character does not belong to an existing box")
				i.boxNum = -1
				notBeganRevision.append(i)

func clearAll():
	currentCharactersToRevise.clear()
	notBeganRevision.clear()
	dailyCharacters.clear()
	otherDailyCharacters.clear()
	weeklyCharacters.clear()
	biweeklyCharacters.clear()
	monthlyCharacters.clear()
	quarterYearlyCharacters.clear()
	halfYearlyCharacters.clear()
	yearlyCharacters.clear()
	putInBoxes()

func putInOrder():
	for i in yearlyCharacters:
		if i.dateForNextStudy.isPastCurrentDate() != 1:
			currentCharactersToRevise.append(i)
	for i in halfYearlyCharacters:
		if i.dateForNextStudy.isPastCurrentDate() != 1:
			currentCharactersToRevise.append(i)
	for i in quarterYearlyCharacters:
		if i.dateForNextStudy.isPastCurrentDate() != 1:
			currentCharactersToRevise.append(i)
	for i in monthlyCharacters:
		if i.dateForNextStudy.isPastCurrentDate() != 1:
			currentCharactersToRevise.append(i)
	for i in biweeklyCharacters:
		if i.dateForNextStudy.isPastCurrentDate() != 1:
			currentCharactersToRevise.append(i)
	for i in weeklyCharacters:
		if i.dateForNextStudy.isPastCurrentDate() != 1:
			currentCharactersToRevise.append(i)
	for i in otherDailyCharacters:
		if i.dateForNextStudy.isPastCurrentDate() != 1:
			currentCharactersToRevise.append(i)
	for i in dailyCharacters:
		currentCharactersToRevise.append(i)
	var arrayCopy : Array = currentCharactersToRevise
	currentCharactersToRevise = []
	while arrayCopy.size() > 0:
		var randomIndex = rng.randi()%arrayCopy.size()
		currentCharactersToRevise.append(arrayCopy[randomIndex])
		arrayCopy.remove(randomIndex)


func moveCorrectToNext():
	var currentCharacter : CharacterEntry = currentCharactersToRevise[0]
	currentCharactersToRevise.erase(currentCharacter)
	if (currentCharacter.boxNum == 1 && currentCharacter.dateForNextStudy.isPastCurrentDate() == 1):
		currentCharactersToRevise.append(currentCharacter)
		return
	
	var newBox : int = currentCharacter.boxNum
	if (newBox != 8):
		newBox += 1
	currentCharacter.changeBox(newBox)

func resetCharacter():
	var currentCharacter : CharacterEntry = currentCharactersToRevise[0]
	currentCharactersToRevise.erase(currentCharacter)
	currentCharacter.changeBox(1)
	currentCharactersToRevise.append(currentCharacter)
