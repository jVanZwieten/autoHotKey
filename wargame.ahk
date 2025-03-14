#SingleInstance force
; constants
global attackMoveKey="i"
global reverseKey="]"
global moveFastKey="/"
global toggleGunsKey="y"
global regroupKey="p"
global spreadKey="u"
global landKey="["
global changeAltitudeKey="o"
global firePositionKey="r"
global smokePositionKey="z"

global unitLabelPosition:={x:600, y:930}
global radarGroupNumber:=7
global radarOnFrequency:=600
global radarOffFrequency:=440

; variables
global gunQuantity
global radarStatus:=true

; hotkeys
GroupAdd, wargame, ahk_exe wargame.exe
GroupAdd, wargame, ahk_exe wargame3.exe
#IfWinActive ahk_group wargame

    ^RButton::
    +^RButton::Send %attackMoveKey%
    !RButton::
    +!RButton::Send %reverseKey%
    XButton1::
    +XButton1::
    ^!RButton::
    +!^RButton::Send %moveFastKey%
    XButton2::
    +XButton2::Send %firePositionKey%
    ^RButton Up::
    !RButton Up::
    XButton1 Up::
    XButton2 Up::
    ^!RButton Up::Send {LButton}
    +^RButton Up::
    +!RButton Up::
    +XButton1 Up::
    +XButton2 Up::
    +!^RButton Up::Send +{LButton}

    ^e::SendInput %toggleGunsKey%
    !e::toggleRadar()
    ^r::HE1Gun()
    !r::linearHEMission()
    ^z::smoke1Gun()
    !z::linearSmokeMission()
    ^`::setGunQuantity()
    ^x::SendInput %regroupKey%
    +^x::SendInput +%regroupKey%
    !x::SendInput %spreadKey%
    +!x::SendInput +%spreadKey%`
    ^f::SendInput %landKey%
    +^f::SendInput +%landKey%
    !f::SendInput %changeAltitudeKey%
    +!f::SendInput +%changeAltitudeKey%

    +F1::customMessage("HE on the way")
    +F2::customMessage("request HE")
    !F1::customMessage("smoke on the way")
    !F2::customMessage("request smoke")
    F5::customMessage("white1 objective")

    ;hot actions
    HE1Gun(){
        fire1AtMouse("HE")
    }

    linearHEMission(){
        linearFireMission("HE")
    }

    smoke1Gun(){
        fire1AtMouse("smoke")
    }

    linearSmokeMission(){
        linearFireMission("smoke")
    }

    setGunQuantity(){
        gunQuantity:=readNumber()
    }

    customMessage(text){
        Send {F4} %text% {Enter}{LButton}
    }

    ; helper functions
    readNumber(){
        InputBox, inputNumber, "Number Input", "Please input a number."
        If inputNumber between 0 and 100
            return inputNumber
    }

    readMouse(){
        MouseGetPos, a, b
        point:={x: a, y: b}
        return point
    }

    readClick(){
        KeyWait, LButton, D
        point:=readMouse()
        return point
    }

    fire1AtMouse(missionType){
        target:=readMouse()
        fire1Gun(target, missionType)
    }

    fire1Gun(target, missionType){
        pointFireMission(target, missionType)
        deselectTopUnit()
        MouseMove, target.x, target.y
    }

    pointFireMission(target, missionType){
        executionKey:=roundType(missionType)
        send %executionKey%{Click, target.x, target.y}
    }

    linearFireMission(missionType){
        if (gunQuantity < 1){
            SoundBeep ;denoting erroneous command
            return
        }

        executionKey:=roundType(missionType)
        startPoint:=readClick()
        Sleep, 125
        endPoint:=readClick()

        fireTargets:=calcFireTargets(startPoint, endPoint, gunQuantity)

        For index, target in fireTargets
            fire1Gun(target, missionType)
    }

    roundType(missionType){
        if(missionType="HE")
            return firePositionKey
        else if(missionType="smoke")
            return smokePositionKey
        else
            throw "Unrecoginized fire mission type."
    }

    calcFireTargets(startPoint, endPoint, gunQuantity){
        delta:={x: calcDelta(startPoint.x, endPoint.x, gunQuantity-1), y: calcDelta(startPoint.y, endPoint.y, gunQuantity-1)}

        fireTargets:=[(startPoint)]

        i:=1
        While, i<gunQuantity{
            fireTargets.push(generateNextPoint(startPoint, delta, i))
            i++
        }

        return fireTargets
    }

    calcDelta(initial, final, divisor){
        delta:= (final-initial)/divisor
        return delta
    }

    generateNextPoint(startPoint, delta, i){
        nextPoint:={x: startPoint.x + delta.x*i, y: startPoint.y + delta.y*i}
        return nextPoint
    }

    deselectTopUnit(){
        x:= % unitLabelPosition.x
        y:= % unitLabelPosition.y
        Send +{Click %x%, %y%}
    }

    toggleRadar(){
        SendInput, %radarGroupNumber%
        Sleep, 50

        SendInput, %toggleGunsKey%
        radarStatus:=!radarStatus
        if(radarStatus)
            f:= radarOnFrequency
        else
            f:= radarOffFrequency
        SoundBeep, f
    }