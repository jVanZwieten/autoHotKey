#SingleInstance force

; constants
global powerPlayCommodityInterval=1800000
global fullCommodityPause=1500
global openPowerContactDelay = 1500
global hardPressDelay = 200

; hotkeys
#IfWinActive ahk_exe EliteDangerous64.exe
    ^0::autoGather()
    ^9::reminder()

    test(){
        SoundBeep
        Send {Space Down}
        Sleep 500
        Send {Space Up}
    }

    reminder(){
        Loop{
            SoundBeep
            Sleep, %powerPlayCommodityInterval%
        }
    }

    ;hot actions
    autoGather(){
        SetKeyDelay, % hardPressDelay, hardPressDelay
        Loop{
            WinActivate ahk_exe EliteDangerous64.exe

            openPowerplay()
            selectCommodity()
            takeAllCommodity()
            resetPowerplayPanel()
            Sleep %powerPlayCommodityInterval%
        }
    }

    openPowerplay(){
        Send, {Space}
        Sleep %openPowerContactDelay%
    }

    selectCommodity(){
        Send s
    }

    takeAllCommodity(){
        holdFor("d", fullCommodityPause)
        Send, {Space}
        Sleep 1500
    }

    resetPowerplayPanel(){
        Send {BackSpace}{BackSpace}
    }

    holdFor(key, duration){
        Send {%key% down}
        Sleep % duration
        Send {%key% up}
    }