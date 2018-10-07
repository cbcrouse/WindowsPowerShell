function Show-Colors()
{
    $colornames = [System.ConsoleColor]::GetNames("consolecolor")
  
    foreach ($colorname in $colornames)
    {
        Write-Host ("{0}    ABCDEFG0123456     " -f $colorname) -ForegroundColor $colorname -BackgroundColor White
        Write-Host ("{0}    ABCDEFG0123456     " -f $colorname) -ForegroundColor White -BackgroundColor $colorname
        Write-Host ("{0}    ABCDEFG0123456     " -f $colorname) -ForegroundColor $colorname -BackgroundColor Black
        Write-Host ("{0}    ABCDEFG0123456     " -f $colorname) -ForegroundColor Black -BackgroundColor $colorname
    }
    
    foreach ($colorname in $colornames)
    {
        Write-Host ("{0}    ABCDEFG0123456     " -f $colorname) -ForegroundColor $colorname
    }
}

Export-ModuleMember -Function * -Alias *