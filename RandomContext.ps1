Add-Type -AssemblyName System.Windows.Forms
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class MouseSimulator {
    [DllImport("user32.dll", CharSet = CharSet.Auto, CallingConvention = CallingConvention.StdCall)]
    public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
    
    public const int MOUSEEVENTF_RIGHTDOWN = 0x08;
    public const int MOUSEEVENTF_RIGHTUP = 0x10;
}
"@

# Bildschirmauflösung ermitteln
$screen = [System.Windows.Forms.Screen]::PrimaryScreen
$width  = $screen.Bounds.Width
$height = $screen.Bounds.Height

while ($true) {
    # aktuelle Mausposition speichern
    $pos = [System.Windows.Forms.Cursor]::Position

    # zufällige Position
    $x = Get-Random -Minimum 0 -Maximum $width
    $y = Get-Random -Minimum 0 -Maximum $height
    [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($x, $y)

    # Rechtsklick simulieren
    [MouseSimulator]::mouse_event([MouseSimulator]::MOUSEEVENTF_RIGHTDOWN, 0, 0, 0, 0)
    Start-Sleep -Milliseconds 50
    [MouseSimulator]::mouse_event([MouseSimulator]::MOUSEEVENTF_RIGHTUP, 0, 0, 0, 0)

    # Maus wieder zurücksetzen
    [System.Windows.Forms.Cursor]::Position = $pos

    # 30 Sekunden warten
    Start-Sleep -Seconds 3
}