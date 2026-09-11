#Requires AutoHotkey v2.0

WM_IME_CONTROL := 0x0283
IMC_GETCONVERSIONMODE := 0x0001
IME_CMODE_NATIVE := 0x0001
SMTO_ABORTIFHUNG := 0x0002

GetFocusedWindow() {
    foregroundWindow := WinExist("A")
    if !foregroundWindow
        return 0

    guiThreadInfo := Buffer(A_PtrSize == 8 ? 72 : 48, 0)
    NumPut("UInt", guiThreadInfo.Size, guiThreadInfo)
    threadId := DllCall("user32\GetWindowThreadProcessId", "Ptr", foregroundWindow, "Ptr", 0, "UInt")
    DllCall("user32\GetGUIThreadInfo", "UInt", threadId, "Ptr", guiThreadInfo)
    focusedWindow := NumGet(guiThreadInfo, A_PtrSize == 8 ? 16 : 12, "Ptr")
    return focusedWindow ? focusedWindow : foregroundWindow
}

focusedWindow := GetFocusedWindow()
imeWindow := DllCall("imm32\ImmGetDefaultIMEWnd", "Ptr", focusedWindow, "Ptr")
conversionMode := 0

try {
    querySucceeded := imeWindow && DllCall(
        "user32\SendMessageTimeoutW",
        "Ptr", imeWindow,
        "UInt", WM_IME_CONTROL,
        "Ptr", IMC_GETCONVERSIONMODE,
        "Ptr", 0,
        "UInt", SMTO_ABORTIFHUNG,
        "UInt", 200,
        "UPtr*", &conversionMode,
        "Ptr"
    )

    FileAppend(querySucceeded ? (conversionMode & IME_CMODE_NATIVE ? "KO" : "EN") : "--", "*")
} catch {
    FileAppend("--", "*")
}
