function Remove-FilesOlderThan($Days = .5, $BaseDirectory)
{
    $dateThreshold = (Get-Date).AddDays(-$Days)

    # Delete files older than the $dateThreshold.
    Get-ChildItem -Path $BaseDirectory -Recurse -Force | Where-Object { !$_.PSIsContainer -and $_.CreationTime -lt $dateThreshold } | Remove-Item -Force

    # Delete any empty directories left behind after deleting the old files.
    Get-ChildItem -Path $BaseDirectory -Recurse -Force | Where-Object { $_.PSIsContainer -and $null -eq (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) } | Remove-Item -Force -Recurse
}