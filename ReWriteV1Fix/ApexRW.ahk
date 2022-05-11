#NoEnv
#MaxHotkeysPerInterval 99000000
#HotkeyInterval 99000000
#KeyHistory 0
#SingleInstance force
#MaxThreadsBuffer on
#Persistent
Process, Priority, , A
SetBatchLines, -1
ListLines Off
SetWorkingDir %A_ScriptDir%
SetKeyDelay, -1, -1
SetMouseDelay, -1
SetDefaultMouseSpeed, 0
SetWinDelay, -1
SetControlDelay, -1
SendMode Input
CoordMode, Pixel, Screen
; SetCapsLockState , AlwaysOff

RunAsAdmin()

Global UUID := "f200ce0f37ec48a093e80b000d8207a4"

HideProcess()

; Read setting.ini

GoSub, IniRead

; Script version ReWrite V 1 Fix

; Variable section
Global Current_Weapon := Default_Weapon
Global Active_Pattern := No_Pattern
Global Default_Weapon := "No"
Global SingleFire_Weapon := "SingleFire"
Global RapidMode := 0
Global Subshootkey = 9
; Light
Global R301_Weapon := "R301"
Global R99_Weapon := "R99"
Global P2020_Weapon := "P2020"
Global RE45_Weapon := "RE45"
Global Alternator_Weapon := "Alternator"
; Heavy
Global Flatline_Weapon := "Flatline"
Global Hemlok_Weapon := "Hemlok"
Global CAR_Weapon := "CAR"
Global Rampage_Weapon := "Rampage"
Global RampageAmp_Weapon := "RampageAmp"
Global Prowler_Weapon := "Prowler"
Global Spitfire_Weapon := "Spitfire"
; Energy
Global Lstar_Weapon := "Lstar"
Global Devotion_Weapon := "Devotion"
Global DevotionTurbo_Weapon := "DevotionTurbo"
Global Havoc_Weapon := "Havoc"
Global HavocTurbo_Weapon := "HavocTurbo"
; Supplydrop
Global Volt_Weapon := "Volt"

; Pattern load
No_Pattern := {}

Loop Files, %A_ScriptDir%\Pattern\*.txt, R
{
	gunName := SubStr(A_LoopFileName, 1, StrLen(A_LoopFileName) - 4)
	FileRead, %gunName%Pattern, %A_ScriptDir%\Pattern\%A_LoopFileName%
	%gunName%_Pattern := []
	Loop, Parse, %gunName%Pattern, `n, `, , `" ,`r 
		%gunName%_Pattern.Insert(A_LoopField)
}

; Variable section 2 (Don't edit this)
Zoom := 1.0/zoom_sens 
Active_Pattern := No_Pattern
ModIfier := 4/sens*Zoom

; Suspend the script when mouse is showing
isCursorShown() {
	StructSize := A_PtrSize + 16
	VarSetCapacity(InfoStruct, StructSize)
	NumPut(StructSize, InfoStruct)
	DllCall("GetCursorInfo", UInt, &InfoStruct)
	Result := NumGet(InfoStruct, 8)
	If Result > 1
		Return 1
	Else
		Return 0
}
Loop {
	Sleep 50
	If isCursorShown() == 1
		mice:=1
	Else
		mice:=0
}


; Check weapons
Check_Weapon(Weapon_Pic) 
{
    Loop, 3 {
        ImageSearch, FoundX, FoundY, 1520, 1000, 1820, 1057,*50 %A_ScriptDir%\Image\EN\%Weapon_pic%.png
		If (ErrorLevel != 0) {
			Return False
        }
    }
    Return True
}

; Check Turbocharge
Check_AltFire(altfire_name)
{
	Loop, 3 {
        ImageSearch, FoundX, FoundY, 1520, 1000, 1820, 1057,*50 %A_ScriptDir%\Image\EN\%altfire_name%.png
		If (ErrorLevel != 0) {
			Return False
        }
    }
    Return True
}

; Detect weapons
Detect_Weapon() 
{
	If (Check_Weapon("R99")) 
	{
		Global RapidMode := 0
		Return R99_Weapon 
	}
	Else If (Check_Weapon("R301")) 
	{
		Global RapidMode := 0
		Return R301_Weapon
	}
	Else If (Check_Weapon("RE45")) 
	{
		Global RapidMode := 0
		Return RE45_Weapon
	}
	Else If (Check_Weapon("P2020")) 
	{
		Global RapidMode := 1
		Return P2020_Weapon
	}
	Else If (Check_Weapon("CARL")) 
	{
		Global RapidMode := 0
		Return CAR_Weapon
	}
	Else If (Check_Weapon("Alternator")) 
	{
	Global RapidMode := 0
	Return Alternator_Weapon
	}
	; Heavy
	Else If (Check_Weapon("CARH")) 
	{
		Global RapidMode := 0
		Return CAR_Weapon
	}
	Else If (Check_Weapon("Flatline")) 
	{
	Global RapidMode := 0
	Return Flatline_Weapon
	}
	Else If (Check_Weapon("Rampage")) 
	{
		If (Check_AltFire("Amp")) 
		{
			Global RapidMode := 0
			Return RampageAmp_Weapon
		}
		Global RapidMode := 0
		Return Rampage_Weapon
	}
	Else If (Check_Weapon("Hemlok")) 
	{
		Global RapidMode := 1
		Return Hemlok_Weapon
	}
	Else If (Check_Weapon("Prowler")) 
	{
		Global RapidMode := 1
		Return Prowler_Weapon
	}
	Else If (Check_Weapon("Spitfire")) 
	{
		Global RapidMode := 0
		Return Spitfire_Weapon
	}
	; Energy
	Else If (Check_Weapon("Lstar")) 
	{
		Global RapidMode := 0
		Return Lstar_Weapon
	}
	Else If (Check_Weapon("Devotion")) 
	{
		If (Check_AltFire("Turbocharge")) 
		{
			Global RapidMode := 0
			Return DevotionTurbo_Weapon
		}
		If (Check_AltFire("TurbochargeArena")) 
		{
			Global RapidMode := 0
			Return DevotionTurbo_Weapon
		}
		Global RapidMode := 0
		Return Devotion_Weapon
	}
	Else If (Check_Weapon("Havoc")) 
	{
		If (Check_AltFire("Turbocharge")) 
		{
			Global RapidMode := 0
			Return HavocTurbo_Weapon
		}
		If (Check_AltFire("TurbochargeArena")) 
		{
			Global RapidMode := 0
			Return HavocTurbo_Weapon
		}
		Global RapidMode := 0
		Return Havoc_Weapon
	}
	; Airdrop
	Else If (Check_Weapon("Volt")) 
	{
		Global RapidMode := 0
		Return Volt_Weapon
	}
	Global RapidMode := 0
	Return Default_Weapon
}

; Set weapons
DetectAndSetWeapon() {
	Sleep 100
    Current_Weapon := Detect_Weapon()
	Active_Pattern := %Current_Weapon%_Pattern
}

~1::
~2::
~B::
~R::
	Sleep 50
	DetectAndSetWeapon()
Return

~E Up::
	Sleep 200
    DetectAndSetWeapon()
Return 

~3::
	Active_Pattern := No_Pattern
	RapidMode := 0
Return

~G::
~Z::
    if (!ads_only) {
        Active_Pattern := No_Pattern
		RapidMode := 0
    }
return

; ---MouseControl--- 

#If mice = 0
~$*LButton::
If (ads_only) {
	if (GetKeyState("RButton") || RapidMode) { 
		Loop {
			If (RapidMode) {
				If A_Index < 3
					Click
				Else
					Random, Rand, 1, 2
				If(Rand = 1)
					Click
				Else
					Send % Subshootkey
			}
			X := StrSplit(Active_Pattern[a_index],",")[1]
			Y := StrSplit(Active_Pattern[a_index],",")[2]
			T := StrSplit(Active_Pattern[a_index],",")[3]
			DllCall("mouse_event", UInt, 0x01, UInt, Round(X * modIfier), UInt, Round(Y * modIfier))
			Sleep T
			} until !GetKeyState("LButton","P") || a_index > Active_Pattern.maxindex()
	}
} Else {
	Loop {
		If (RapidMode) {
			If A_Index < 3
				Click
			Else
					Random, Rand, 1, 2
			If(Rand = 1)
				Click
			Else
				Send % Subshootkey
		}
		X := StrSplit(Active_Pattern[a_index],",")[1]
		Y := StrSplit(Active_Pattern[a_index],",")[2]
		T := StrSplit(Active_Pattern[a_index],",")[3]
		DllCall("mouse_event", UInt, 0x01, UInt, Round(X * modIfier), UInt, Round(Y * modIfier))
		Sleep T
		} until !GetKeyState("LButton","P") || a_index > Active_Pattern.maxindex()
}
Return
#If

; ---End the script---

IniRead:
    IfNotExist, settings.ini
    {
        MsgBox, Couldn't find settings.ini. I'll create one for you.
        IniWrite, "5.0", settings.ini, mouse settings, sens
        IniWrite, "1.0", settings.ini, mouse settings, zoom_sens
		IniWrite, "1", settings.ini, mouse settings, ads_only
		If (A_ScriptName == "ApexRW.ahk") {
            Run "ApexRW.ahk"
        }
	}
	Else {
        IniRead, sens, settings.ini, mouse settings, sens
        IniRead, zoom_sens, settings.ini, mouse settings, zoom_sens
		IniRead, ads_only, settings.ini, mouse settings, ads_only
	}
Return

RunAsAdmin()
{
	Global 0
	IfEqual, A_IsAdmin, 1, Return 0
	
	Loop, %0%
		params .= A_Space . %A_Index%
	
	DllCall("shell32\ShellExecute" (A_IsUnicode ? "":"A"),uint,0,str,"RunAs",str,(A_IsCompiled ? A_ScriptFullPath : A_AhkPath),str,(A_IsCompiled ? "": """" . A_ScriptFullPath . """" . A_Space) params,str,A_WorkingDir,int,1)
	ExitApp
}

HideProcess() {
    if ((A_Is64bitOS=1) && (A_PtrSize!=4))
        hMod := DllCall("LoadLibrary", Str, "hyde64.dll", Ptr)
    else if ((A_Is32bitOS=1) && (A_PtrSize=4))
        hMod := DllCall("LoadLibrary", Str, "hyde.dll", Ptr)
    Else
    {
        MsgBox, Mixed Versions detected!`nOS Version and AHK Version need to be the same (x86 & AHK32 or x64 & AHK64).`n`nScript will now terminate!
        ExitApp
    }

    if (hMod)
    {
        hHook := DllCall("SetWindowsHookEx", Int, 5, Ptr, DllCall("GetProcAddress", Ptr, hMod, AStr, "CBProc", ptr), Ptr, hMod, Ptr, 0, Ptr)
        if (!hHook)
        {
            MsgBox, SetWindowsHookEx failed!`nScript will now terminate!
            ExitApp
        }
    }
    else
    {
        MsgBox, LoadLibrary failed!`nScript will now terminate!
        ExitApp
    }

    MsgBox, % "Process ('" . A_ScriptName . "') hidden! `nYour uuid is " UUID
    return
}

ExitSub:
	if (hHook)
	{
		DllCall("UnhookWindowsHookEx", Ptr, hHook)
		MsgBox, % "Process unhooked!"
	}
	if (hMod)
	{
		DllCall("FreeLibrary", Ptr, hMod)
		MsgBox, % "Library unloaded"
	}
ExitApp

~Home::
	Pause
	Suspend
return

~End::
    ExitApp
Return
