#Requires AutoHotkey v2.0

;Commands with <Ctrl>
^+h::Send("{Left}")
^+j::Send("{Down}")
^+k::Send("{Up}")
^+l::Send("{Right}")
^+y::Send("{Home}")
^+o::Send("{End}")
^+9::Send("{Delete}")
^+0::Send("{Backspace}")

; Pasting current date with <Ctrl> + <Alt> + \
^!\:: {
    time := FormatTime(A_now, "yyMMdd")
    Send(time)
}

; Pasting current date_time with <Ctrl> + <Shift> + <Alt> + \
^+!\:: {
    time := FormatTime(A_now, "yyMMdd_HHmmss")
    Send(time)
}
