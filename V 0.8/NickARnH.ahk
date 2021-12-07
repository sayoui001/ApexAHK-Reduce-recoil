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
If not A_IsAdmin {
    Run *RunAs "%A_ScriptFullPath%"
    ExitApp
}
; SetCapsLockState , AlwaysOff

GoSub, IniRead

; Script Version V 0.8

; ----VarSection----

Global Current_Weapon := Default_Weapon
Global Active_Pattern := No_Pattern
Global Default_Weapon := "No"
; Light
Global R301_Weapon := "R301"
Global R99_Weapon := "R99"
Global P2020_Weapon := "P2020"
Global RE45_Weapon := "RE45"
; Heavy
Global Flatline_Weapon := "Flatline"
; Global Wingman_Weapon := "Wingman"
Global Prowler_Weapon := "Prowler"
Global Hemlok_Weapon := "Hemlok"
Global CAR_Weapon := "CAR"
Global Rampage_Weapon := "Rampage"
Global RampageAmp_Weapon := "RampageAmp"
; Energy
Global Volt_Weapon := "Volt"
Global Lstar_Weapon := "Lstar"
Global Devotion_Weapon := "Devotion"
Global DevotionTurbo_Weapon := "DevotionTurbo"
Global Havoc_Weapon := "Havoc"
Global HavocTurbo_Weapon := "HavocTurbo"
; Airdrop
Global Alternator_Weapon := "Alternator"
Global Spitfire_Weapon := "Spitfire"
; Global G7_Weapon := "G7"
Global MiniGun_Weapon := "MiniGun"
; Var
Global SingleFire_Weapon := "SingleFire"
Global RapidMode := 0

; ---Edit weapon selection keys bind---

bind_1 = 1
bind_2 = 2
bind_1B = WheelDown
bind_2B = WheelUp
bind_Ult = z
bind_run = 3
bind_grenade = g 
Subshootkey = 9 ; Bind to your secondary fire button.

; ---Hotkey set---

Hotkey, ~$*%bind_1%, key_1
Hotkey, ~$*%bind_2%, key_2
; Hotkey, ~$*%bind_1B%, key_1B 
; Hotkey, ~$*%bind_2B%, key_2B
Hotkey, ~$*%bind_Ult%, key_Ult
Hotkey, ~$*%bind_run%, key_3
Hotkey, ~$*%bind_grenade%, key_g

; ---Pattern---

No_Pattern := {}

Loop Files, %A_ScriptDir%\Pattern\*.txt, R
{
	gunName := SubStr(A_LoopFileName, 1, StrLen(A_LoopFileName) - 4)
	FileRead, %gunName%Pattern, %A_ScriptDir%\Pattern\%A_LoopFileName%
	%gunName%_Pattern := []
	Loop, Parse, %gunName%Pattern, `n, `, , `" ,`r 
		%gunName%_Pattern.Insert(A_LoopField)
}

; ---Var Section 2 (Don't edit this)---

Zoom := 1.0/zoom_sens 
Active_Pattern := No_Pattern
ModIfier := 4/sens*Zoom

; ---Suspend the script when mouse is showing---

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

; ---Check Weapon---

Check_Weapon(Weapon_Pic) {
    loop, 3 {
		global lang
        ImageSearch, FoundX, FoundY, 1520, 1000, 1824, 1057,*50 %A_ScriptDir%\Image\%lang%\%Weapon_pic%.png
		If (ErrorLevel != 0) {
			Return False
        }
    }
    Return True
}

Detect_Weapon() {
	; Light
	If (Check_Weapon("R99")) {
	Global RapidMode := 0
	Return R99_Weapon 
	}
	Else If (Check_Weapon("R301")) {
	Global RapidMode := 0
	Return R301_Weapon
	}
	Else If (Check_Weapon("RE45")) {
	Global RapidMode := 0
	Return RE45_Weapon
	}
	Else If (Check_Weapon("P2020")) {
	Global RapidMode := 1
	Return P2020_Weapon
	}
	Else If (Check_Weapon("CARL")) {
	Global RapidMode := 0
	Return CAR_Weapon
	}
	; Heavy
	Else If (Check_Weapon("CARH")) {
	Global RapidMode := 0
	Return CAR_Weapon
	}
	Else If (Check_Weapon("Flatline")) {
	Global RapidMode := 0
	Return Flatline_Weapon
	}
	Else If (Check_Weapon("Rampage")) {
		If (Check_Weapon("Amp")) {
		Global RapidMode := 0
		Return RampageAmp_Weapon
		}
	Global RapidMode := 0
	Return Rampage_Weapon
	}
	Else If (Check_Weapon("Hemlok")) {
	Global RapidMode := 1
	Return Hemlok_Weapon
	}
	Else If (Check_Weapon("Prowler")) {
	Global RapidMode := 1
	Return Prowler_Weapon
	}
	; Else If (Check_Weapon("Wingman")) {
	; Global RapidMode := 1
	; Return Wingman_Weapon
	; }
	; Energy
	Else If (Check_Weapon("Volt")) {
	Global RapidMode := 0
	Return Volt_Weapon
	}
	Else If (Check_Weapon("Lstar")) {
	Global RapidMode := 0
	Return Lstar_Weapon
	}
	Else If (Check_Weapon("Devotion")) {
		If (Check_Weapon("Turbocharge")) {
		Global RapidMode := 0
		Return DevotionTurbo_Weapon
		}
		If (Check_Weapon("TurbochargeArena")) {
		Global RapidMode := 0
		Return DevotionTurbo_Weapon
		}
	Global RapidMode := 0
	Return Devotion_Weapon
	}
	Else If (Check_Weapon("Havoc")) {
		If (Check_Weapon("Turbocharge")) {
		Global RapidMode := 0
		Return HavocTurbo_Weapon
		}
		If (Check_Weapon("TurbochargeArena")) {
		Global RapidMode := 0
		Return HavocTurbo_Weapon
		}
	Global RapidMode := 0
	Return Havoc_Weapon
	}
	; Airdrop
	Else If (Check_Weapon("Spitfire")) {
	Global RapidMode := 0
	Return Spitfire_Weapon
	}
	Else If (Check_Weapon("Alternator")) {
	Global RapidMode := 0
	Return Alternator_Weapon
	}
	; Else If (Check_Weapon("G7")) {
	; Global RapidMode := 1
	; Return G7_Weapon
	; }	
	Else If (Check_Weapon("MiniGun")) {
	Global RapidMode := 0
	Return MiniGun_Weapon
	}
	Global RapidMode := 0
	Return Default_Weapon
}

DetectAndSetWeapon() {
    Sleep 100
    Current_Weapon := Detect_Weapon()
	Active_Pattern := %Current_Weapon%_Pattern
}

key_1:
key_2:
; key_1B:
; key_2B:
    Sleep 50
    DetectAndSetWeapon()
Return

key_Ult:
~E Up::
	Sleep 200
    DetectAndSetWeapon()
Return 

key_3:
Key_G:
	Active_Pattern := No_Pattern
	RapidMode := 0
Return

; ---MouseControl--- 

#If mice = 0
~$*LButton::
Sleep 5
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
Return
#If

; ---End the script---

IniRead:
    IfNotExist, settings.ini
    {
        MsgBox, Couldn't find settings.ini. I'll create one for you.
        IniWrite, "5.0", settings.ini, mouse settings, sens
        IniWrite, "1.0", settings.ini, mouse settings, zoom_sens
		IniWrite, "EN"`n, settings.ini, language settings, lang
	}
	Else {
        IniRead, sens, settings.ini, mouse settings, sens
        IniRead, zoom_sens, settings.ini, mouse settings, zoom_sens
		IniRead, lang, settings.ini, language settings, lang
	}
Return

~End::
    ExitApp
Return
