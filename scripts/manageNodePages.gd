extends Node

@onready var allPages = $"."
@onready var PrevButton = $"../PreviousPage"
@onready var NextButton = $"../NextPage"

var actualPage = 1
@export var maxPage = 2


func _on_previous_page_pressed() -> void:
	actualPage -= 1
	UpdatePagesAndButtons()


func _on_next_page_pressed() -> void:
	actualPage += 1
	UpdatePagesAndButtons()
	
func UpdatePagesAndButtons() -> void:
	#Mettre à jour les boutons
	if actualPage == maxPage:
		NextButton.disabled = true
		PrevButton.disabled = false
	elif actualPage == 1:
		NextButton.disabled = false
		PrevButton.disabled = true
	else:
		NextButton.disabled = false
		PrevButton.disabled = false
		
	#Mettre à jour les pages
	for child in allPages.get_children():
		if child.name == "NodesP" + str(actualPage):
			child.set_visible(true)
		else:
			child.set_visible(false)
		
