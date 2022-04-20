#NoEnv
#SingleInstance force
#MaxThreadsBuffer on
SendMode Input
SetWorkingDir %A_ScriptDir%
DetectHiddenWindows On
SetTitleMatchMode RegEx

RunAsAdmin()

Gosub, IniRead

; global variable
script_version := "ReWrite V 2"

; Convert sens to sider format
sider_sen := sens * 10

; GUI
SetFormat, float, 0.1
Gui, Font, S30 CDefault Bold, Verdana
Gui, Add, Text, x71 y-1 w330 h50 , Apex-NoRecoil
Gui, Font, ,
Gui, Add, Text, x216 y49 w90 h20 , %script_version%
Gui, Add, GroupBox, x11 y69 w450 h140 , Settings
Gui, Font, S13 Bold, 
Gui, Add, Text, x162 y89 w50 h30 , sens:
Gui, Add, Slider, x212 y89 w100 h30 vsider_sen gSlide range0-100 tickinterval1 AltSubmit, %sider_sen%
if (ads_only == "1") {
    Gui, Add, CheckBox, x182 y129 w110 h30 vads_only Checked, ads_only
} else {
    Gui, Add, CheckBox, x182 y129 w110 h30 vads_only, ads_only
}
Gui, Add, Text, x122 y169 w169 h30 , resolution:
Gui, Font, S10, 
if (resolution == "3840x2160") {
    Gui, Add, DropDownList, x222 y169 vresolution, 1280x720|1366x768|1600x900|1680x1050|1728x1080|1920x1080|1920x1690|2560x1440|3840x2160||
} else if (resolution == "2560x1440") {
    Gui, Add, DropDownList, x222 y169 vresolution, 1280x720|1366x768|1600x900|1680x1050|1728x1080|1920x1080|1920x1690|2560x1440||3840x2160|
} else if (resolution == "1920x1690") {
    Gui, Add, DropDownList, x222 y169 vresolution, 1280x720|1366x768|1600x900|1680x1050|1728x1080|1920x1080|1920x1690||2560x1440|3840x2160|
} else if (resolution == "1728x1080") {
    Gui, Add, DropDownList, x222 y169 vresolution, 1280x720|1366x768|1600x900|1680x1050|1728x1080||1920x1080|1920x1690|2560x1440|3840x2160|
} else if (resolution == "1680x1050") {
    Gui, Add, DropDownList, x222 y169 vresolution, 1280x720|1366x768|1600x900|1680x1050||1728x1080|1920x1080|1920x1690|2560x1440|3840x2160|
} else if (resolution == "1600x900") {
    Gui, Add, DropDownList, x222 y169 vresolution, 1280x720|1366x768|1600x900||1680x1050|1728x1080|1920x1080|1920x1690|2560x1440|3840x2160|
} else if (resolution == "1366x768") {
    Gui, Add, DropDownList, x222 y169 vresolution, 1280x720|1366x768||1600x900|1600x1050|1728x1080|1920x1080|1920x1690|2560x1440|3840x2160|
} else if (resolution == "1280x720") {
    Gui, Add, DropDownList, x222 y169 vresolution, 1280x720||1366x768|1600x900|1600x1050|1728x1080|1920x1080|1920x1690|2560x1440|3840x2160|
} else {
    Gui, Add, DropDownList, x222 y169 vresolution, 1280x720|1366x768|1600x900|1680x1050|1728x1080|1920x1080||1920x1690|2560x1440|3840x2160|
} 
Gui, Font, S18 Bold, 
Gui, Add, Button, x142 y224 w190 h40 gbtSave, Save and Run!
Gui, Font, , 
Gui, Add, Link, x128 y277 w400 h18 , Original GitHub : <a href="https://github.com/mgsweet/Apex-NoRecoil-2021">mgsweet/Apex-NoRecoil-2021</a>    
Gui, Add, Link, x119 y297 w400 h18 , sayoui001's Thread : <a href="https://www.unknowncheats.me/forum/apex-legends/466312-ahk-reduce-recoil-script-auto-detect-weapon.html">sayoui001 on UnknownCheats</a>
ActiveMonitorInfo(X, Y, Width, Height)
xPos := Width / 2 - 477 / 2
yPos := Height / 2 - 335 / 2
Gui, Show, x%xPos% y%yPos% h325 w477, Apex NoRecoil %script_version%
Return

Slide:
    Gui,Submit,NoHide
    sens := sider_sen/10
    tooltip % sens
    SetTimer, RemoveToolTip, 500
return

RemoveToolTip:
    SetTimer, RemoveToolTip, Off
    ToolTip
return

IniRead:
IfNotExist, settings.ini 
{
    MsgBox, Couldn't find settings.ini. I'll create one for you.
    IniWrite, "1080x1920"`n, settings.ini, screen settings, resolution
    IniWrite, "5.0", settings.ini, mouse settings, sens
    IniWrite, "1.0", settings.ini, mouse settings, zoom_sens
    IniWrite, "1"`n, settings.ini, mouse settings, ads_only
    if (A_ScriptName == "Start.ahk") {
        Run "Start.ahk"
    }
} 
Else {
    IniRead, resolution, settings.ini, screen settings, resolution
    IniRead, sens, settings.ini, mouse settings, sens
    IniRead, zoom_sens, settings.ini, mouse settings, zoom_sens
    IniRead, ads_only, settings.ini, mouse settings, ads_only
}
return

btSave:
    Gui, submit
    IniWrite, "%resolution%", settings.ini, screen settings, resolution
    IniWrite, "%sens%", settings.ini, mouse settings, sens
    IniWrite, "%ads_only%", settings.ini, mouse settings, ads_only
    if (A_ScriptName == "Start.ahk") {
        CloseScript("ApexRW.ahk")
        Run "ApexRW.ahk"
    }
ExitApp

CloseScript(Name) {
	DetectHiddenWindows On
	SetTitleMatchMode RegEx
	IfWinExist, i)%Name%.* ahk_class AutoHotkey
		{
		WinClose
		WinWaitClose, i)%Name%.* ahk_class AutoHotkey, , 2
		If ErrorLevel
			return "Unable to close " . Name
		else
			return "Closed " . Name
		}
	else
		return Name . " not found"
	}

ActiveMonitorInfo(ByRef X, ByRef Y, ByRef Width, ByRef Height)
{
    CoordMode, Mouse, Screen
    MouseGetPos, mouseX, mouseY
    SysGet, monCount, MonitorCount
    Loop %monCount% {
        SysGet, curMon, Monitor, %a_index%
        if ( mouseX >= curMonLeft and mouseX <= curMonRight and mouseY >= curMonTop and mouseY <= curMonBottom ) {
            X := curMonTop
            y := curMonLeft
            Height := curMonBottom - curMonTop
            Width := curMonRight - curMonLeft
            return
        }
    }
}

RunAsAdmin()
{
	Global 0
	IfEqual, A_IsAdmin, 1, Return 0
	
	Loop, %0%
		params .= A_Space . %A_Index%
	
	DllCall("shell32\ShellExecute" (A_IsUnicode ? "":"A"),uint,0,str,"RunAs",str,(A_IsCompiled ? A_ScriptFullPath : A_AhkPath),str,(A_IsCompiled ? "": """" . A_ScriptFullPath . """" . A_Space) params,str,A_WorkingDir,int,1)
	ExitApp
}

GuiClose:
ExitApp
