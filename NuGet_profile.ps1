Write-Host "NuGet Profile loaded." -ForegroundColor Yellow -BackgroundColor Black

[System.Collections.ArrayList]$global:elapsedList = New-Object System.Collections.ArrayList

function Get-EventLogs ($LogName="application", [int]$PageSize = 10)
{
    $index = 0
    $allLogs = Get-EventLog $LogName
    $allLogs = $allLogs | Sort-Object -Property Index -Descending
    do
    {
        if ($index -eq 0)
        {
            $eventLogs = $allLogs | Select-Object -First $PageSize
        }
        else
        {
            $eventLogs = $($allLogs | Where-Object {$_.Index -lt $index})
            $first10 = $eventLogs | Select-Object -First $PageSize
            $eventLogs = $first10
        }
        if ($null -ne $eventLogs)
        {
            $oldestEvent = $($eventLogs | Sort-Object -Property Index)[0]
            $index = $oldestEvent.Index
        }
        if ($index -eq 0)
        {
            Write-Host "No $LogName logs found." -ForegroundColor DarkYellow
            Exit
        }
        $eventLogs
    }
    while($(Read-Host -Prompt "Press Enter to get load more... Enter 'c' to cancel.") -ne 'c' -and $index -ne 0)
}

function Measure-Time([scriptblock]$Script, [string]$Name)
{
    $stopwatch =  [system.diagnostics.stopwatch]::StartNew()
    $value = Invoke-Command -ScriptBlock $script
    $elapsed = $stopwatch.Elapsed; $stopwatch.Stop()
    $elapsedList.Add($elapsed)

    Write-Host "Elapsed $($Name): $($elapsed)" -ForegroundColor DarkBlue
    
    return $value
}