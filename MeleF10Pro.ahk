/*
MELE 10 Hotkey program
Created by Max MC Costa .s.u.m.o.t.o.y.
GNU License
Do NOT remove this message even if you modify code!

MENU			024000		147456
Change Audio Source	024803		149507
CALL UP			024903		149763
CALL DOWN		024A03		150019
Smart Assistant		024B03		150275


*/


;Must be in auto-execute section if I want to use the constants

#Include %A_ScriptDir%\AHKHID.ahk



;Create GUI to receive messages

Gui, +LastFound

hGui := WinExist()



;Intercept WM_INPUT messages

WM_INPUT := 0xFF

OnMessage(WM_INPUT, "InputMsg")



;Register Remote Control with RIDEV_INPUTSINK (so that data is received even in the background)

r := AHKHID_Register(12, 1, hGui, RIDEV_INPUTSINK)

InputMsg(wParam, lParam) {

    Local devh, iKey, sLabel

   

    Critical

   

    ;Get handle of device

    devh := AHKHID_GetInputInfo(lParam, II_DEVHANDLE)

   

    ;Check for error

    If (devh <> -1) ;Check that it is my HP remote

        And (AHKHID_GetDevInfo(devh, DI_DEVTYPE, True) = RIM_TYPEHID)

        And (AHKHID_GetDevInfo(devh, DI_HID_VENDORID, True) = 999)

        And (AHKHID_GetDevInfo(devh, DI_HID_PRODUCTID, True) = 3329)

        And (AHKHID_GetDevInfo(devh, DI_HID_VERSIONNUMBER, True) = 272) {

        ;Get data

        iKey := AHKHID_GetInputData(lParam, uData)

       

        ;Check for error

        If (iKey <> -1) {

           

            ;Get keycode (located at the 6th byte)

            iKey := ((NumGet(uData, 0, "UChar")*65536) + (NumGet(uData, 1, "UChar")*256) + (NumGet(uData, 2, "UChar")))

           


            ;Call the appropriate sub if it exists

            If IsLabel(iKey)

                Gosub, %iKey%

        }

    }

}

Return

147456:
    SendInput ^+!a ; MENU
Return

149507:
    SendInput ^+!b ; Change Audio Source
Return

149763:
    SendInput ^+!c ; CALL UP
Return

150019:
    SendInput ^+!d ; CALL DOWN
Return

150275:
    SendInput ^+!e ; Smart Assistant
Return

