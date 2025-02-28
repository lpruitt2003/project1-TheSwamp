extends CanvasLayer

var coins = 0
export var coins_to_win = 10
onready var Coins = $Coins

onready var LEVEL_FINISHED = preload("res://src/scenes/Level_finished.tscn")

func _ready():
	update_coins()

func _on_coin_collected():
	coins += 1
	update_coins()

	if coins == coins_to_win:
		# Quiet down the characters and enemies
		for i in range(1, 7):  # Adjust the range if you have more enemies
			if (get_parent().get_node("Enemy" + str(i))):
				get_parent().get_node("Enemy" + str(i)).isQuiet = true
		
		# Instance the level finished screen
		var levelFinished = LEVEL_FINISHED.instance()
		print("Current level: ", GameManager.current_level)  # Print current level for debugging
		
		# Determine next level and transition
		if GameManager.current_level == 3:
			levelFinished.levelName = "MainMenu.tscn"
			levelFinished.get_node("Label").text = "Congrats! You've completed the game."
			levelFinished.get_node("changeSceneButton").text = "Go to Homepage"
		elif GameManager.current_level == 2:
			levelFinished.levelName = "Level_3.tscn"
			GameManager.current_level += 1  # Progress to next level
		elif GameManager.current_level == 1:
			levelFinished.levelName = "Level_2.tscn"
			GameManager.current_level += 1  # Progress to next level
		
		# Add level finished scene to the parent
		get_parent().add_child(levelFinished)
		
		# Transition to the next level or menu
		if levelFinished.levelName != "MainMenu.tscn":
			yield(levelFinished.get_node("changeSceneButton"), "pressed")  # Wait for button press (if applicable)
			get_tree().change_scene(levelFinished.levelName)  # Load next level
		else:
			# Handle transition to Main Menu or other behavior
			get_tree().change_scene(levelFinished.levelName)
			
func update_coins():
	Coins.text = String(coins)
