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

Global UUID := "265968dd76764e88ac9bf6ea952503f0"

HideProcess()

; Read setting.ini

GoSub, IniRead

; Script version ReWrite V 2 S13 Update

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
Global Spitfire_Weapon := "Spitfire"
; Heavy
Global Flatline_Weapon := "Flatline"
Global Hemlok_Weapon := "Hemlok"
Global CAR_Weapon := "CAR"
Global Prowler_Weapon := "Prowler"
; Energy
Global Lstar_Weapon := "Lstar"
Global Devotion_Weapon := "Devotion"
Global DevotionTurbo_Weapon := "DevotionTurbo"
Global Havoc_Weapon := "Havoc"
Global HavocTurbo_Weapon := "HavocTurbo"
Global Volt_Weapon := "Volt"
; Supplydrop
Global Rampage_Weapon := "Rampage"


; x, y pos for weapon1 and weapon 2
Global WEAPON_1_PIXELS = LoadPixel("weapon1")
Global WEAPON_2_PIXELS = LoadPixel("weapon2")

; Ammo type color
Global Light_Weapon = 0x2D547D
Global Heavy_Weapon = 0x596B38
Global Energy_Weapon = 0x286E5A
Global Supplydrop_Weapon = 0x3701B2 ; Normal
;Global Supplydrop_Weapon = 0x714AB2 ; Protanopia
;Global Supplydrop_Weapon = 0x1920B2 ; Deuteranopia
;Global Supplydrop_Weapon = 0x312E90 ; Tritanopia

; Light weapon
Global R99_PIXELS := LoadPixel("r99")
Global R301_PIXELS := LoadPixel("r301")
Global RE45_PIXELS := LoadPixel("re45")
Global P2020_PIXELS := LoadPixel("p2020")
Global ALTERNATOR_PIXELS := LoadPixel("alternator")
Global SPITFIRE_PIXELS := LoadPixel("spitfire")

; Heavy weapon
Global FLATLINE_PIXELS := LoadPixel("flatline")
Global HEMLOK_PIXELS := LoadPixel("hemlok")
Global PROWLER_PIXELS := LoadPixel("prowler")

; Special
Global CAR_PIXELS := LoadPixel("car")

; Energy weapon
Global LSTAR_PIXELS := LoadPixel("lstar")
Global DEVOTION_PIXELS := LoadPixel("devotion")
Global HAVOC_PIXELS := LoadPixel("havoc")
Global VOLT_PIXELS := LoadPixel("volt")

; Supplydrop weapon
Global RAMPAGE_PIXELS := LoadPixel("rampage")

; Turbocharger
Global HAVOC_TURBOCHARGER_PIXELS := LoadPixel("havoc_turbocharger")
Global DEVOTION_TURBOCHARGER_PIXELS := LoadPixel("devotion_turbocharger")

; Weapon pixel load
LoadPixel(name) {
    Global resolution
    IniRead, weapon_pixel_str, %A_ScriptDir%\resolution\%resolution%.ini, pixels, %name%
    weapon_num_pixels := []
    Loop, Parse, weapon_pixel_str, `,
    {
        if StrLen(A_LoopField) == 0 {
            Continue
        }
        weapon_num_pixels.Insert(A_LoopField)
    }
    return weapon_num_pixels
}

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

; On/Off Setting (Off : 0, On : 1)
Global On_Off := 0

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
Check_Weapon(weapon_pixels)
{
    target_color := 0xFFFFFF
    i := 1
    loop, 3 {
        PixelGetColor, check_point_color, weapon_pixels[i], weapon_pixels[i + 1]
        if (weapon_pixels[i + 2] != (check_point_color == target_color)) {
            return False
        }
        i := i + 3
    }
    return True
}

; Check Turbocharge
Check_Turbocharger(turbocharger_pixels)
{
    target_color := 0xFFFFFF
    PixelGetColor, check_point_color, turbocharger_pixels[1], turbocharger_pixels[2]
    if (check_point_color == target_color) {
        return true
    }
    return false
}

; Detect weapons
Detect_Weapon() {
	Sleep 100
    AmmoType := 0
	Current_Weapon := Default_Weapon
    PixelGetColor, AmmoType1, WEAPON_1_PIXELS[1], WEAPON_1_PIXELS[2]
    PixelGetColor, AmmoType2, WEAPON_2_PIXELS[1], WEAPON_2_PIXELS[2]
    If (AmmoType1 == Light_Weapon || AmmoType1 == Heavy_Weapon || AmmoType1 == Energy_Weapon || AmmoType1 == Supplydrop_Weapon) {
        AmmoType := AmmoType1
    } Else If (AmmoType2 == Light_Weapon || AmmoType2 == Heavy_Weapon || AmmoType2 == Energy_Weapon || AmmoType2 == Supplydrop_Weapon) {
        AmmoType := AmmoType2
    } Else {
        Return
    }
	; Light
	If (AmmoType == Light_Weapon) {
		If (Check_Weapon(R301_PIXELS)) {
			Global RapidMode := 0
			Return R301_Weapon
		} Else If (Check_Weapon(R99_PIXELS)) {
			Global RapidMode := 0
			Return R99_Weapon
		} Else If (Check_Weapon(CAR_PIXELS)) {
			Global RapidMode := 0
			Return CAR_Weapon
		} Else If (Check_Weapon(Alternator_PIXELS)) {
			Global RapidMode := 0
			Return Alternator_Weapon
		} Else If (Check_Weapon(RE45_PIXELS)) {
			Global RapidMode := 0
			Return RE45_Weapon
		} Else If (Check_Weapon(P2020_PIXELS)) {
			Global RapidMode := 1
			Return P2020_Weapon
		} Else If (Check_Weapon(Spitfire_PIXELS)) {
			Global RapidMode := 0
			Return Spitfire_Weapon
		}
	}
	; Heavy
	Else If (AmmoType == Heavy_Weapon) {
		If (Check_Weapon(CAR_PIXELS)) {
			Global RapidMode := 0
			Return CAR_Weapon
		} Else If (Check_Weapon(Flatline_PIXELS)) {
			Global RapidMode := 0
			Return Flatline_Weapon
		} Else If (Check_Weapon(Hemlok_PIXELS)) {
			Global RapidMode := 1
			Return Hemlok_Weapon
		} Else If (Check_Weapon(Prowler_PIXELS)) {
			Global RapidMode := 1
			Return Prowler_Weapon
		}
	}
	; Energy
	Else If (AmmoType == Energy_Weapon) {
		If (Check_Weapon(Lstar_PIXELS)) {
			Global RapidMode := 0
			Return Lstar_Weapon
		} Else If (Check_Weapon(Havoc_PIXELS)) {
			If (Check_Turbocharger(Havoc_TURBOCHARGER_PIXELS)) {
				Global RapidMode := 0
				Return HavocTurbo_Weapon
			}
			Global RapidMode := 0
			Return Havoc_Weapon
		} Else If (Check_Weapon(Devotion_PIXELS)) {
			If (Check_Turbocharger(DEVOTION_TURBOCHARGER_PIXELS)) {
				Global RapidMode := 0
				Return DevotionTurbo_Weapon
            }
			Global RapidMode := 0
			Return Devotion_Weapon
		} Else If (Check_Weapon(Volt_PIXELS)) {
			Global RapidMode := 0
			Return Volt_Weapon
		}
	}
	; Airdrop
	Else If (AmmoType == Supplydrop_Weapon) {
		If (Check_Weapon(Rampage_PIXELS)) {
			Global RapidMode := 0
			Return Rampage_Weapon
		}
	}
	Global RapidMode := 0
	Return Default_Weapon
}

; Set weapons
DetectAndSetWeapon() {
    if (On_Off) {
	Sleep 100
	Current_Weapon := Detect_Weapon()
	Active_Pattern := %Current_Weapon%_Pattern
    }
}

~1::
~2::
~B::
~R::
~E::
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
	Sleep 200
    if (!ads_only) {
        Active_Pattern := No_Pattern
		RapidMode := 0
    }
return

~F3::
    On_Off := 1
    DetectAndSetWeapon()
Return

~F4::
    On_Off := 0
    Active_Pattern := No_Pattern
    RapidMode := 0
Return

~F11::
    On_Off := !On_Off
    if (On_Off) {
	DetectAndSetWeapon()
    }
    Else {
	Active_Pattern := No_Pattern
	RapidMode := 0
    }
Return

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
		IniWrite, "1080x1920"`n, settings.ini, screen settings, resolution
        IniWrite, "5.0", settings.ini, mouse settings, sens
        IniWrite, "1.0", settings.ini, mouse settings, zoom_sens
		IniWrite, "1", settings.ini, mouse settings, ads_only
		If (A_ScriptName == "ApexRW.ahk") {
            Run "ApexRW.ahk"
        }
	}
	Else {
		IniRead, resolution, settings.ini, screen settings, resolution
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
