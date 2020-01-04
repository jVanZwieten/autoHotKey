#SingleInstance force
SetKeyDelay, 200, 30
SetMouseDelay 100, 30

; constants
global engineBoostWait=7000
global autodockWait=160000
global autoLaunchWait=75000
global stationServicesWait=5000
global commoditiesPanelBottomHold=4500

global bookmarksPoint={X:158, Y:255}

global station1={Bookmark: {X:135, Y:380}
    , Plot:{X:415, Y:300}
    , SuperCruiseNav: "s"
    , SuperCruiseWait: 90000
    , SelectSellCommodity: Func("station1SelectSellCommodity")
    , SelectBuyCommodity: Func("station1SelectBuyCommodity")}
global station2={Bookmark: {X:130, Y:408}
    , Plot:{X:415, Y:325}
    , SuperCruiseNav: "ss"
    , SuperCruiseWait: 100000
    , SelectSellCommodity: Func("station2SelectSellCommodity")
    , SelectBuyCommodity: Func("station2SelectBuyCommodity")}
global stations= [station1, station2]

station1SelectSellCommodity(){
    Send {s 16}{Space}
    Sleep 500
}

station1SelectBuyCommodity(){
    Send {s 16}{Space}
    Sleep 500
}

station2SelectSellCommodity(){
    Send {s 16}{Space}
    Sleep 500
}

station2SelectBuyCommodity(){
    Send {s 5}{Space}
    Sleep 500
}

; variables
global stationIndex=1
global twoWay=True

; hotkeys
#IfWinActive ahk_exe EliteDangerous64.exe
^0::autoTrade()
^9::test()

test(){
    navigateToNextStation()
}

;hot actions
autoTrade(){
    superCruise(stationIndex)
    autoDock()
    trade(stationIndex)
    autoLaunch()
    navigateToNextStation()
    manueverToJump()
}

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
    engineBoost()
    Sleep 3000
    Send {F1}qd{Space}{F1}x
    Sleep %autodockWait%
    SoundBeep
}

engineBoost(){
    Send {Tab}
    Sleep %engineBoostWait%
    SoundBeep
}

trade(stationIndex){
    openStationServices()
    if(twoWay or stationIndex==2)
        sell(stationIndex)
    if(twoWay or stationIndex==1)
        buy(stationIndex)
    refuel()
    exitMenu()
}

openStationServices(){
    Send {Space}
    Sleep %stationServicesWait%
    SoundBeep
}

openComodities(){
    Send s{Space}
    Sleep 1200
}

sell(stationIndex){
    openComodities()
    openSell()
    sellCommodity(stationIndex)
    exitMenu()
}

openSell(){
    Send s{Space}
    Sleep 500
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
    openComodities()
    buyCommodity(stationIndex)
    exitMenu()
}

buyCommodity(stationIndex){
    Send d
    stations[stationIndex].SelectBuyCommodity()
    
    Send ww{d down}
    Sleep 1800
    Send {d up}
    
    Send s{Space}
    Sleep 2000
}

exitMenu(){
    Send {BackSpace}
    Sleep 1000
    SoundBeep
}

refuel(){
    Send dds{Space}
    Sleep 700
    Send s{Space}
    Sleep 700
}

autoLaunch(){
    Send w{Space}
}

navigateToNextStation(){
    incrementStationIndex(stationIndex)
    openGalaxyMap()
    plotRoute(stationIndex)
    exitMenu()
    exitMenu()
}

incrementStationIndex(currentIndex){
    stationIndex= % 3-currentIndex
}

openGalaxyMap(){
    Send {F1}eaasssw{Space}
}

plotRoute(stationIndex){
    clickBookMarks()
    clickStationBookmark(stationIndex)
    clickPlotRoute(stationIndex)

}

clickBookMarks(){
    Click % bookmarksPoint.X "," bookmarksPoint.Y
}

clickStationBookmark(stationIndex){
    Click % stations[stationIndex].Bookmark.X "," stations[stationIndex].Bookmark.Y
}

clickPlotRoute(stationIndex){
    Click % stations[stationIndex].Plot.X "," stations[stationIndex].Plot.Y
}

manueverToJump(){
    Sleep %autoLaunchWait%
    engineBoost()
    engineBoost()
    Send j
}