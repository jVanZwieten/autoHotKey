#SingleInstance force
SetKeyDelay, 200, 30
SetMouseDelay 100, 30

; constants
global powerPlayCommodityInterval=1800000
global fullMediaPause=2000
global ppTestInterval=10000

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

        openPowerContact()
        selectMedia()
        takeAllMedia()s
        exitMenu()
        exitMenu()
        Sleep %powerPlayCommodityInterval%
    }
}

ensureWindowActive(){
    SoundBeep
    Sleep 500
    WinActivate ahk_exe EliteDangerous64.exe
}

openPowerContact(){
    Send s{Space}
    Sleep 1500
}

selectMedia(){
    Send ss
}

takeAllMedia(){
    Send {d Down}
    Sleep %fullMediaPause%
    Send {d Up}{Space}
    Send 1500
}

exitMenu(){
    Send {BackSpace}
    Sleep 1000
}