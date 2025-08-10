#SingleInstance force
SetKeyDelay, 400, 40
SetMouseDelay 100, 40

; constants
global engineBoostWait=10000
global autodockWait=60000
global autoLaunchWait=15000
global stationServicesWait=5000
global galaxyMapWait=4000
global plotHold = 2000

global commoditiesPanelBottomHold=4500

global bookmarksPoint={X:60, Y:180}

global station1={Bookmark: {X:400, Y:275}
    , SuperCruiseNav: "s"
    , SuperCruiseWait: 130000
    , SelectSellCommodity: Func("station1SelectSellCommodity")
    , SelectBuyCommodity: Func("station1SelectBuyCommodity")
    , type: "orbital"}
global station2={Bookmark: {X:400, Y:350}
    , SuperCruiseNav: "s"
    , SuperCruiseWait: 220000
    , SelectSellCommodity: Func("station2SelectSellCommodity")
    , SelectBuyCommodity: Func("station2SelectBuyCommodity")
    , type: "orbital"}
global stations= [station1, station2]

station1SelectSellCommodity(){
    scrollToCommodityPanelBottom()
    Send {w 43}{Space} ; bertrandite
    Sleep 500
}

station1SelectBuyCommodity(){
    scrollToCommodityPanelBottom()
    Send {w 11}{Space} ; silver
    Sleep 500
}

station2SelectSellCommodity(){
    scrollToCommodityPanelBottom()
    Send {w 32}{Space} ; silver
    Sleep 500
}

station2SelectBuyCommodity(){
    Send {s 18}{Space} ; bertrandite
    Sleep 500
}

; variables
global stationIndex=1
global twoWay=False

; hotkeys
#IfWinActive ahk_exe EliteDangerous64.exe
^!s::Pause
^!r::Reload

^1::autoTrade()
^2::autoTrade2()
^9::test()

; hot actions
test(){
    navigateToNextStation()
}

openMap(){
}

autoTrade(){
    if(stations[stationIndex].SuperCruiseWait > 0)
        superCruise(stationIndex)
    autoDock()
    trade(stationIndex)
    autoLaunch()
    navigateToNextStation()
    manueverToJump()
}

autoTrade2(){
    stationIndex=2
    autoTrade()
}

; utilities
superCruise(stationIndex){
    engageSuperCruiseAssist(stationIndex)
    Sleep % stations[stationIndex].SuperCruiseWait
    SoundBeep
}

engageSuperCruiseAssist(stationIndex){
    toggleNavMenu()
    Send % "d" stations[stationIndex].SuperCruiseNav "{Space}d{Space}"
    toggleNavMenu()
}

toggleNavMenu(){
    Send {F1}
    Sleep 1000
}

autoDock(){
    stationType = % stations[stationIndex].type
    if(stationType == "orbital" || stationType == "colonyship"){
        toggleFlightAssist()
        engineBoost()
        Sleep, %engineBoostWait%
        engineBoost()
        Sleep 3000
    } else
        KeyWait, 0

    Send {F1}qqd{Space}{F1}zz
    Sleep %autodockWait%
    SoundBeep
}

toggleFlightAssist(){
    Send z
}

engineBoost(){
    Send {Tab}
}

trade(stationIndex){
    openStationServices()
    if(twoWay or stationIndex==2)
        if(stations[stationIndex].type == "colonyship")
            transferAllToColonyship()
        else
            sell(stationIndex)

    if(twoWay or stationIndex==1)
        buy(stationIndex)
    exitMenu()

    refuel()
}

openStationServices(){
    Send {Space}
    Sleep %stationServicesWait%
    SoundBeep
}

openCommodities(){
    Send d{Space}
    Sleep 1200
}

sell(stationIndex){
    openCommodities()
    openSell()
    sellCommodity(stationIndex)
    exitMenu()
}

transferAllToColonyship(){
    scrollToCommodityPanelBottom()
    Send wdd{Space}a{Space}
    Sleep 2000
    exitMenu()
}

openSell(){
    Send s{Space}
    Sleep 1000
    Send d
}

sellCommodity(stationIndex){
    stations[stationIndex].SelectSellCommodity()
    Send s{Space}
    Sleep 2000
    SoundBeep
}

scrollToCommodityPanelBottom(){
    Send {s down}
    Sleep %commoditiesPanelBottomHold%
    Send {s up} 
}

buy(stationIndex){
    openCommodities()
    buyCommodity(stationIndex)
    exitMenu()
}

buyCommodity(stationIndex){
    Send d
    stations[stationIndex].SelectBuyCommodity()
    
    Send w{d down}
    Sleep 2000
    Send {d up}
    
    Send s{Space}
    Sleep 2000
}

exitMenu(){
    Send {BackSpace}
}

refuel(){
    Send w{Space}
}

autoLaunch(){
    Send ss{Space}
}

navigateToNextStation(){
    incrementStationIndex(stationIndex)
    toggleGalaxyMap()
    Sleep % galaxyMapWait
    plotRoute(stationIndex)
    toggleGalaxyMap()
}

incrementStationIndex(currentIndex){
    stationIndex= % otherIndex(currentIndex)
}

otherIndex(index){
    return 3 - index
}

toggleGalaxyMap(){
    Send {RCtrl down}m{RCtrl up}
}

plotRoute(stationIndex){
    openBookMarks()
    Sleep 1000
    plotToStationBookmark(stationIndex)
    Sleep 1000
}

openBookMarks(){
    Click % bookmarksPoint.X "," bookmarksPoint.Y
}

plotToStationBookmark(stationIndex){
    x = % stations[stationIndex].Bookmark.X
    y = % stations[stationIndex].Bookmark.Y
    Click, %x% %y% Down
    Sleep %plotHold%
    Click, Up
}

clickPlotRoute(stationIndex){
    Click % stations[stationIndex].Plot.X "," stations[stationIndex].Plot.Y
}

manueverToJump(){
    stationType = % stations[stationIndex].type
    if(stationType == "orbital" || stationType == "colonyship"){
        if(stationType == "orbital")
            Sleep %autoLaunchWait%
        else
            Sleep 5000

        engineBoost()
        Sleep, %engineBoostWait%
        engineBoost()
        Sleep, %engineBoostWait%
        Send f
    }else
        Send {F6}
}