extends Node2D

var HPMAX:int = 10
var hp:int = HPMAX+0

func init(hpmax):
    HPMAX = hpmax
    change_hp(HPMAX+1)

func change_hp(amount):
    hp = clamp(hp+amount,0,HPMAX)
    $SquareGreen.scale.x = float(hp)/float(HPMAX)
    if(hp==HPMAX): visible = false
    else: visible = true
