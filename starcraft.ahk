global attackMoveKey="i"


#SingleInstance force
#IfWinActive ahk_exe StarCraft.exe

*^RButton Up::attackMove()

attackMove(){
    send %attackMoveKey%
    Sleep, 50
    if(GetKeyState(Shift))
        send +{LButton}
    else
        send {LButton}
}