<#
.SYNOPSIS
    Remove files recursively from a directory
.DESCRIPTION
    This function removes all items from a specified directory older than specified days
.PARAMETER Days
    Remove items older than days
.PARAMETER BaseDirectory
    Remove all items recursively from this directory
.EXAMPLE
    C:\PS> Remove-FilesOlderThan -Days .5 -BaseDirectory "C:\Temp\Test"
.NOTES
    Author:         Casey Crouse
    Created On:     10/07/2018
#>
function Remove-FilesOlderThan()
{
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        $Days = .5,
        [Parameter(Mandatory=$true, Position = 1, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        $BaseDirectory
    )

    $dateThreshold = (Get-Date).AddDays(-$Days)

    # Delete files older than the $dateThreshold.
    Get-ChildItem -Path $BaseDirectory -Recurse -Force  Where-Object { !$_.PSIsContainer -and $_.CreationTime -lt $dateThreshold }  Remove-Item -Force

    # Delete any empty directories left behind after deleting the old files.
    Get-ChildItem -Path $BaseDirectory -Recurse -Force  Where-Object { $_.PSIsContainer -and $null -eq (Get-ChildItem -Path $_.FullName -Recurse -Force  Where-Object { !$_.PSIsContainer }) }  Remove-Item -Force -Recurse
}