Write-Host "CUAH Master Profile loaded." -ForegroundColor Yellow -BackgroundColor Black

$Modules  = @( Get-ChildItem -Recurse -Path "$PSScriptRoot\Modules\*.psm1" -ErrorAction SilentlyContinue )

#Dot source the files
Write-Host "Loading modules..." -ForegroundColor DarkBlue
Foreach($import in $Modules)
{
    Try
    {
        Write-Host $import.Name -ForegroundColor DarkGreen
        $manifestName = $import.fullname.Replace("psm1", "psd1")
        Import-Module $manifestName
        Get-Command -Module $import.name | Out-Null
    }
    Catch
    {
        Write-Error -Message "Failed to import module $($import.fullname): $_"
    }
}