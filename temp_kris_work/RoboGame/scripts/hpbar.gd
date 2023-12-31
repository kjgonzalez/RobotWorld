extends Node2D

var HPMAX:int = 10
var hp:int = HPMAX+0
@onready var barbase:ColorRect = $barbase
@onready var barhp:ColorRect = $barhp

func init(hpmax,clrbase=Color(255,0,0),clrhp=Color(0,255,0)):
    HPMAX = hpmax
    change_hp(HPMAX+1)
    barbase.color = clrbase
    barhp.color = clrhp

func change_hp(amount):
    hp = clamp(hp+amount,0,HPMAX)
    $barhp.scale.x = float(hp)/float(HPMAX)
    if(hp==HPMAX): visible = false
    else: visible = true
