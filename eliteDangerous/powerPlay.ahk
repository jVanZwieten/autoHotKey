#SingleInstance force
SetKeyDelay, 200, 30
SetMouseDelay 100, 30

; constants
global powerPlayCommodityInterval=1800000
global fullMediaPause=2000
global ppTestInterval=10000
global openPowerContactDelay = 1500

; hotkeys
#IfWinActive ahk_exe EliteDangerous64.exe
^0::autoGather()
^9::test()

test(){
    Sleep 1000
    WinActivate ahk_exe EliteDangerous64.exe
    Send s
}

;hot actions
autoGather(){
    Loop{
        ensureWindowActive()

        selectMedia()
        takeAllMedia()
        Sleep %powerPlayCommodityInterval%
        exitMenu()
    }
}

ensureWindowActive(){
    WinActivate ahk_exe EliteDangerous64.exe
}

openPowerContact(){
    Send {Space}
    Sleep openPowerContactDelay
}

selectMedia(){
    Send oo{Space}
}

takeAllMedia(){
    Send {e Down}
    Sleep %fullMediaPause%
    Send {e Up}{Space}
}

exitMenu(){
    Send {BackSpace}
}