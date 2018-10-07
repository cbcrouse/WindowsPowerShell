Write-Host "NuGet Profile loaded." -ForegroundColor Yellow -BackgroundColor Black

[System.Collections.ArrayList]$global:elapsedList = New-Object System.Collections.ArrayList

function Get-EventLogs ($LogName="application", [int]$PageSize = 10)
{
    $index = 0
    $allLogs = Measure-Time -Script { Get-EventLog $LogName } -Name "GET ALL LOGS"
    $allLogs = Measure-Time -Script { $allLogs | Sort-Object -Property Index -Descending } -Name "SORT ALL LOGS"
    do
    {
        if ($index -eq 0)
        {
            $eventLogs = Measure-Time -Script { $allLogs | Select-Object -First $PageSize } -Name "TAKE $($PageSize) LOGS"
        }
        else
        {
            $eventLogs = Measure-Time -Script { $($allLogs | Where-Object {$_.Index -lt $index}) } -Name "GET NEXT LOGS AFTER INDEX - $($index)"
            $first10 = Measure-Time -Script { $eventLogs | Select-Object -First $PageSize } -Name "TAKE $($PageSize) LOGS"
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

    $elapsedList.RemoveAt(0)
    $elapsedList.RemoveAt(0)
    $stats = $elapsedList | Measure-Object -Average TotalSeconds
    "Average Page Time: $($stats.Average)"
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

Get-EventLogs -PageSize 2000