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

GoSub, IniRead

; Script Version V 0.5

; ----VarSection----

Global Current_Weapon := Default_Weapon
Global Active_Pattern := No_Pattern
Global Default_Weapon := "No"
; Light
Global R301_Weapon := "R301"
Global R99_Weapon := "R99"
Global P2020_Weapon := "P2020"
Global RE45_Weapon := "RE45"
Global G7_Weapon := "G7"
; Heavy
Global Flatline_Weapon := "Flatline"
Global Wingman_Weapon := "Wingman"
Global Prowler_Weapon := "Prowler"
Global Hemlok_Weapon := "Hemlok"
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
Global MiniGun_Weapon := "MiniGun"
; Var
Global SingleFire_Weapon := "SingleFire"
Global RapidMode := 0

; ---Edit your sens and weapon selection keys bind---

bind_1 = 1
bind_2 = 2
bind_1B = WheelDown
bind_2B = WheelUp
bind_run = 3
bind_grenade = g 
Subshootkey = 9 ; Bind to your secondary fire button.

; ---Hotkey set---

Hotkey, ~$*%bind_1%, key_1
Hotkey, ~$*%bind_2%, key_2
Hotkey, ~$*%bind_1B%, key_1B
Hotkey, ~$*%bind_2B%, key_2B
Hotkey, ~$*%bind_run%, key_3
Hotkey, ~$*%bind_grenade%, key_g

; ---Pattern---

No_Pattern := {}

; ---------- Light Ammo Pattern ----------

; --- R301 ---
FileRead, R301Pattern, %A_ScriptDir%\Pattern\R301.txt
R301_Pattern := []
Loop, Parse, R301Pattern, `n, `, , `" ,`r 
	R301_Pattern.Insert(A_LoopField)

; --- R99 ---
FileRead, R99Pattern, %A_ScriptDir%\Pattern\R99.txt
R99_Pattern := []
Loop, Parse, R99Pattern, `n, `, , `" ,`r 
	R99_Pattern.Insert(A_LoopField)

; --- Alternator ---
FileRead, AlternatorPattern, %A_ScriptDir%\Pattern\Alternator.txt
Alternator_Pattern := []
Loop, Parse, AlternatorPattern, `n, `, , `" ,`r 
	Alternator_Pattern.Insert(A_LoopField)

; --- RE45 ---
FileRead, RE45Pattern, %A_ScriptDir%\Pattern\RE45.txt
RE45_Pattern := []
Loop, Parse, RE45Pattern, `n, `, , `" ,`r 
	RE45_Pattern.Insert(A_LoopField)

; --- P2020 ---
FileRead, P2020Pattern, %A_ScriptDir%\Pattern\P2020.txt
P2020_Pattern := []
Loop, Parse, P2020Pattern, `n, `, , `" ,`r 
	P2020_Pattern.Insert(A_LoopField)

; --- G7 ---
FileRead, G7Pattern, %A_ScriptDir%\Pattern\G7.txt
G7_Pattern := []
Loop, Parse, G7Pattern, `n, `, , `" ,`r 
	G7_Pattern.Insert(A_LoopField)

; ---------- Heavy Ammo Weapon ----------

; --- Flatline ---
FileRead, FlatlinePattern, %A_ScriptDir%\Pattern\Flatline.txt
Flatline_Pattern := []
Loop, Parse, FlatlinePattern, `n, `, , `" ,`r 
	Flatline_Pattern.Insert(A_LoopField)

; --- Rampage ---
FileRead, RampagePattern, %A_ScriptDir%\Pattern\Rampage.txt
Rampage_Pattern := []
Loop, Parse, RampagePattern, `n, `, , `" ,`r 
	Rampage_Pattern.Insert(A_LoopField)

; --- RampageAmp ---
FileRead, RampageAmpPattern, %A_ScriptDir%\Pattern\RampageAmp.txt
RampageAmp_Pattern := []
Loop, Parse, RampageAmpPattern, `n, `, , `" ,`r 
	RampageAmp_Pattern.Insert(A_LoopField)
 
; --- Spitfire ---
FileRead, SpitfirePattern, %A_ScriptDir%\Pattern\Spitfire.txt
Spitfire_Pattern := []
Loop, Parse, SpitfirePattern, `n, `, , `" ,`r 
	Spitfire_Pattern.Insert(A_LoopField)

; --- Hemlok ---
FileRead, HemlokPattern, %A_ScriptDir%\Pattern\Hemlok.txt
Hemlok_Pattern := []
Loop, Parse, HemlokPattern, `n, `, , `" ,`r 
	Hemlok_Pattern.Insert(A_LoopField)

; --- Prowler ---
FileRead, ProwlerPattern, %A_ScriptDir%\Pattern\Prowler.txt
Prowler_Pattern := []
Loop, Parse, ProwlerPattern, `n, `, , `" ,`r 
	Prowler_Pattern.Insert(A_LoopField)

; --- Wingman ---
FileRead, WingmanPattern, %A_ScriptDir%\Pattern\Wingman.txt
Wingman_Pattern := []
Loop, Parse, WingmanPattern, `n, `, , `" ,`r 
	Wingman_Pattern.Insert(A_LoopField)

; ---------- Energy Ammo Weapon ----------

; Volt
FileRead, VoltPattern, %A_ScriptDir%\Pattern\Volt.txt
Volt_Pattern := []
Loop, Parse, VoltPattern, `n, `, , `" ,`r 
	Volt_Pattern.Insert(A_LoopField)

; Lstar
FileRead, LstarPattern, %A_ScriptDir%\Pattern\Lstar.txt
Lstar_Pattern := []
Loop, Parse, LstarPattern, `n, `, , `" ,`r 
	Lstar_Pattern.Insert(A_LoopField)

; Havoc
FileRead, HavocPattern, %A_ScriptDir%\Pattern\Havoc.txt
Havoc_Pattern := []
Loop, Parse, HavocPattern, `n, `, , `" ,`r 
	Havoc_Pattern.Insert(A_LoopField)

; HavocTurbo
FileRead, HavocTurboPattern, %A_ScriptDir%\Pattern\HavocTurbo.txt
HavocTurbo_Pattern := []
Loop, Parse, HavocTurboPattern, `n, `, , `" ,`r 
	HavocTurbo_Pattern.Insert(A_LoopField)

; Devotion
FileRead, DevotionPattern, %A_ScriptDir%\Pattern\Devotion.txt
Devotion_Pattern := []
Loop, Parse, DevotionPattern, `n, `, , `" ,`r 
	Devotion_Pattern.Insert(A_LoopField)

; DevotionTurbo
FileRead, DevotionTurboPattern, %A_ScriptDir%\Pattern\DevotionTurbo.txt
DevotionTurbo_Pattern := []
Loop, Parse, DevotionTurboPattern, `n, `, , `" ,`r 
	DevotionTurbo_Pattern.Insert(A_LoopField)

; ---------- SPECIAL WEAPON ----------

; --- MiniGun ---
FileRead, MiniGunPattern, %A_ScriptDir%\Pattern\MiniGun.txt
MiniGun_Pattern := []
Loop, Parse, MiniGunPattern, `n, `, , `" ,`r 
	MiniGun_Pattern.Insert(A_LoopField)

; ---Var Section 2 (Don't edit this)---

Zoom := 1.0/zoom_sens 
Active_Pattern := No_Pattern
ModIfier := 3.40/sens*Zoom

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
        ImageSearch, FoundX, FoundY, 1570, 955, 1720, 1027,*70 %A_ScriptDir%\NewImage\%Weapon_pic%.png
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
	Else If (Check_Weapon("G7")) {
	Global RapidMode := 1
	Return G7_Weapon
	}	
	; Heavy
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
	Else If (Check_Weapon("Wingman")) {
	Global RapidMode := 1
	Return Wingman_Weapon
	}
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
key_1B:
key_2B:
    DetectAndSetWeapon()
Return

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
if (GetKeyState("RButton") || RapidMode) { 
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
}
Return
#If

; ---End the script---

IniRead:
    IfNotExist, settings.ini
    {
        MsgBox, Couldn't find settings.ini. I'll create one for you.
        IniWrite, "5.0", settings.ini, mouse settings, sens
        IniWrite, "1.0"`n, settings.ini, mouse settings, zoom_sens
	}
	Else {
        IniRead, sens, settings.ini, mouse settings, sens
        IniRead, zoom_sens, settings.ini, mouse settings, zoom_sens
	}
Return

~End::
    ExitApp
Return
