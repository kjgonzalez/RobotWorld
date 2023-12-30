extends Node2D


func _process(delta):
    $StartMenuGear.rotation_degrees +=delta*5

func _on_btn_back_pressed():
    get_tree().change_scene_to_file("res://scenes/screen_startmenu.tscn")
