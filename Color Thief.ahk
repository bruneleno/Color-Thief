#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance Force
;Menu, Tray, Icon , %A_ScriptDir%\Support_Files\TrayIcon.ico
#NoTrayIcon
Settings = 0
Target := A_ScriptFullPath
StartMenu = %A_AppData%\Microsoft\Windows\Start Menu\Programs\
LinkFile = %A_AppData%\Microsoft\Windows\Start Menu\Programs\Color Thief.lnk
IniRead, StartMenu, %A_ScriptDir%\Support_Files\settings.ini, StartMenu, present



if StartMenu = 1
goto PickColor
if StartMenu != 1
goto Setup


SetSystemCursor()
{
	Cursors = 32512,32513,32514,32515,32516,32640,32641,32642,32643,32644,32645,32646,32648,32649,32650,32651
	Loop, Parse, Cursors, `,
	{
		Cursor = %A_ScriptDir%\Support_Files\%A_Loopfield%.cur
		CursorHandle := DllCall( "LoadCursorFromFile", Str,Cursor )
		DllCall( "SetSystemCursor", Uint,CursorHandle, Int,A_Loopfield )
	}
}


RestoreCursors() 
{
	SPI_SETCURSORS := 0x57
	DllCall( "SystemParametersInfo", UInt,SPI_SETCURSORS, UInt,0, UInt,0, UInt,0 )
}


PickColor:
{
SetSystemCursor()
sleep, 100
Loop 
{
MouseGetPos, X, Y
X := X+16
Y := Y+12
PixelGetColor, hex, %X%, %Y%, RGB
hex := SubStr(hex, 3)
tooltip, #%hex%
if GetKeyState("LButton") = 1
break
loop, 10 {
sleep, 12
if GetKeyState("LButton") = 1
brk = 1
break
}
if brk = 1
{
brk = 0
break
}
}
clipboard = %hex%
tooltip, Valor copiado!
RestoreCursors()
sleep, 900
tooltip
ExitApp
}
return



Setup:
{
Gui, Setter:New
Gui, Setter:Color , FFFFFF
Gui, Setter:Show, w380 h60, Color Picker Settings
Gui, Setter:-MaximizeBox -MinimizeBox
Gui, Setter:Font, s16 q5
Gui, Setter:Add, Text,, Hello.`nLet's define some shortcuts.
Gui, Setter:Font, s11 q5
Gui, Setter:Add, Checkbox, Checked vStartMenuBox gStartMenuBox, Create a shortcut in the start menu?
Gui, Setter:Add, Checkbox, Checked vShortcutBox gShortcutBox, Assign a keyboard shortcut to it?
Gui, Setter:Font, s09 q5
Gui, Add, Hotkey, x40 vChosenHotkey gChosenHotkey Limit178 , ^!p
Gui, Setter:Font, s11 q5
Gui, Setter:Add, Checkbox, Checked vStartApp x20, Launch app when done?
Gui, Setter:Font, s7 q5
Gui, Setter:Add, Text, cGray, You won't see this next time you launch the app.`nTo open these settings, press "F1" while running the app.
Gui, Setter:Add, Button, x20 w280 gButtonOK vButtonOK, OK
Gui, Setter:Add, Link, cGray,`n<a href="%A_ScriptDir%\License.txt"> © Copyright 2020 Bruno Heleno.</a> Check my <a href="https://linktr.ee/bruneleno">portfolio</a>`nor <a href="mailto:brunohelenob@gmail.com">contact me</a>. Also consider <a href="https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=EEQ5C56XVNBAN&source=url"> supporting my work</a>.
Gui, Setter:Show, NA AutoSize


StartMenuBox:
Gui, Submit, NoHide
if StartMenuBox = 0
{
GuiControl, Disable, ShortcutBox
GuiControl, Disable, ChosenHotkey
}
if StartMenuBox = 1
{
GuiControl, Enable, ShortcutBox
GuiControl, Enable, ChosenHotkey
}
return


ShortcutBox:
Gui, Submit, NoHide
if ShortcutBox = 0
{
GuiControl, Disable, ChosenHotkey
}
if ShortcutBox = 1
{
GuiControl, Enable, ChosenHotkey
}



ChosenHotkey:
GuiControl,, ChosenHotkey , % "^!" ChosenHotkey
return


ButtonOK:
Gui, Submit, NoHide
ChosenHotkey := SubStr(ChosenHotkey, 3)
if StartMenuBox = 1
{
if ShortcutBox = 1
FileCreateShortcut, %Target%, %LinkFile%,,,,, %ChosenHotkey%
if ShortcutBox = 0
FileCreateShortcut, %Target%, %LinkFile%
}
IniWrite, 1, %A_ScriptDir%\Support_Files\settings.ini, StartMenu, present
Gui, Setter:Destroy
if StartApp = 1
reload
else
ExitApp
return


SetterGuiClose:
Gui, Setter:Destroy
ExitApp
return
}

F1::
RestoreCursors()
IniWrite, 0, %A_ScriptDir%\Support_Files\settings.ini, StartMenu, present
reload
return