using System;
using System.Runtime.InteropServices;

internal static class Program
{
    const int WM_IME_CONTROL = 0x0283;
    const int IMC_GETCONVERSIONMODE = 0x0001;
    const int IME_CMODE_NATIVE = 0x0001;
    const uint SMTO_ABORTIFHUNG = 0x0002;

    [StructLayout(LayoutKind.Sequential)]
    struct RECT
    {
        public int left;
        public int top;
        public int right;
        public int bottom;
    }

    [StructLayout(LayoutKind.Sequential)]
    struct GUITHREADINFO
    {
        public int cbSize;
        public int flags;
        public IntPtr hwndActive;
        public IntPtr hwndFocus;
        public IntPtr hwndCapture;
        public IntPtr hwndMenuOwner;
        public IntPtr hwndMoveSize;
        public IntPtr hwndCaret;
        public RECT rcCaret;
    }

    [DllImport("user32.dll")]
    static extern IntPtr GetForegroundWindow();

    [DllImport("user32.dll")]
    static extern uint GetWindowThreadProcessId(IntPtr hWnd, IntPtr processId);

    [DllImport("user32.dll")]
    static extern bool GetGUIThreadInfo(uint idThread, ref GUITHREADINFO info);

    [DllImport("imm32.dll")]
    static extern IntPtr ImmGetDefaultIMEWnd(IntPtr hWnd);

    [DllImport("user32.dll", CharSet = CharSet.Unicode)]
    static extern IntPtr SendMessageTimeout(
        IntPtr hWnd,
        int msg,
        IntPtr wParam,
        IntPtr lParam,
        uint flags,
        uint timeout,
        out UIntPtr result);

    static IntPtr GetFocusedWindow()
    {
        IntPtr foreground = GetForegroundWindow();
        if (foreground == IntPtr.Zero)
        {
            return IntPtr.Zero;
        }

        GUITHREADINFO info = new GUITHREADINFO();
        info.cbSize = Marshal.SizeOf(info);
        GetGUIThreadInfo(GetWindowThreadProcessId(foreground, IntPtr.Zero), ref info);
        return info.hwndFocus != IntPtr.Zero ? info.hwndFocus : foreground;
    }

    static void Main()
    {
        try
        {
            IntPtr focused = GetFocusedWindow();
            IntPtr ime = ImmGetDefaultIMEWnd(focused);
            UIntPtr conversion = UIntPtr.Zero;
            bool querySucceeded = ime != IntPtr.Zero
                && SendMessageTimeout(
                    ime,
                    WM_IME_CONTROL,
                    (IntPtr)IMC_GETCONVERSIONMODE,
                    IntPtr.Zero,
                    SMTO_ABORTIFHUNG,
                    200,
                    out conversion) != IntPtr.Zero;

            if (!querySucceeded)
            {
                Console.Write("--");
                return;
            }

            Console.Write((conversion.ToUInt64() & IME_CMODE_NATIVE) != 0 ? "KO" : "EN");
        }
        catch
        {
            Console.Write("--");
        }
    }
}
