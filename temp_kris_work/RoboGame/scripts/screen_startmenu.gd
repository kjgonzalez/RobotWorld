extends Node2D

@onready var gearicon:Sprite2D = $StartMenuGear

func _process(delta):
    gearicon.rotation_degrees +=delta*5

func _on_btn_start_pressed():
    print('start')
    get_tree().change_scene_to_file("res://scenes/level.tscn")


func _on_btn_options_pressed():
    get_tree().change_scene_to_file("res://scenes/screen_options.tscn")

func _on_btn_quit_pressed():
    print('quitting')
    get_tree().quit()

