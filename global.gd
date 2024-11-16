extends Node2D

# Define global variables here
@export var width := 150
@export var height := 150
var inCollision = []
var level = 1
var actualXP = 0
var maxXP = 10

#true quand on est dans un menu -> zoom et zqsd impossible 
var inMenu : bool

#preset selectionné quand on est dans le menu
var presetSelected = null
#maison selectionné quand on est le menu
var houseSelected = null

#Contient tous les presets créés
var presetsWork = {}

#Contient le preset de chaque maison
var presetsHouses = {}
