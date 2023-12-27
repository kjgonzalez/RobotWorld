extends Node2D

var HPMAX:float = 10
var hp:float = HPMAX+0

func init(hpmax):
    HPMAX = hpmax
    change_hp(HPMAX+1)

func change_hp(amount):
    hp = clamp(hp+amount,0,HPMAX)
    $SquareGreen.scale.x = hp/HPMAX
    if(hp==HPMAX): visible = false
    else: visible = true
