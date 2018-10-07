<#
.SYNOPSIS
    List PowerShell Console Colors and Color Combinations with text
.DESCRIPTION
    Writes out sample text colored with the available console colors and several color combinations of foreground and background.
.EXAMPLE
    C:\PS> Show-ConsoleColors
.OUTPUTS
    String    
.NOTES
    The color combinations are limited. Depending on your host's background color, some colors may be difficult to see.
#>
function Show-ConsoleColors()
{
    [CmdletBinding()]
    [OutputType([String])]
    $colornames = [System.ConsoleColor]::GetNames("consolecolor")
  
    foreach ($colorname in $colornames)
    {
        Write-Host "$colorname" -ForegroundColor $colorname -BackgroundColor White
        Write-Host "$colorname" -ForegroundColor White -BackgroundColor $colorname
        Write-Host "$colorname" -ForegroundColor $colorname -BackgroundColor Black
        Write-Host "$colorname" -ForegroundColor Black -BackgroundColor $colorname
    }
    
    foreach ($colorname in $colornames)
    {
        Write-Host "$colorname" -ForegroundColor $colorname
    }
}
