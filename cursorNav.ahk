#SingleInstance Force
sendWithModifiers(key){
    modifiers := ""
    if GetKeyState("Shift", "P") {
        modifiers .= "+"
    }
    if GetKeyState("Control", "P") {
        modifiers .= "^"
    }
    SendInput(modifiers . key)
}

*!i::{
    sendWithModifiers("{Up}")
    return
}

*!k::{
    sendWithModifiers("{Down}")
    return
}

*!j::{
    sendWithModifiers("{Left}")
    return
}

*!l::{
    sendWithModifiers("{Right}")
    return
}

*!h::{
    sendWithModifiers("{Home}")
    return
}

*!;::{
    sendWithModifiers("{End}")
    return
}

*!u::{
    sendWithModifiers("{PageUp}")
    return
}

*!o::{
    sendWithModifiers("{PageDown}")
    return
}

*!BackSpace::{
    sendWithModifiers("{Delete}")
    return
}