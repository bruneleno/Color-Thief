#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance Force
Menu, Tray, Icon , %A_ScriptDir%\TrayIcon.png



SetSystemCursor()
{
	Cursors = 32512,32513,32514,32515,32516,32640,32641,32642,32643,32644,32645,32646,32648,32649,32650,32651
	Loop, Parse, Cursors, `,
	{
		Cursor = %A_ScriptDir%\Cursor_Icons\%A_Loopfield%.cur
		CursorHandle := DllCall( "LoadCursorFromFile", Str,Cursor )
		DllCall( "SetSystemCursor", Uint,CursorHandle, Int,A_Loopfield )
	}
}


RestoreCursors() 
{
	SPI_SETCURSORS := 0x57
	DllCall( "SystemParametersInfo", UInt,SPI_SETCURSORS, UInt,0, UInt,0, UInt,0 )
}


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
clipboard = #%hex%
tooltip, Valor copiado!
RestoreCursors()
sleep, 900
tooltip
ExitApp