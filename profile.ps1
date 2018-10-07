Write-Host "CUAH Master Profile loaded." -ForegroundColor Yellow -BackgroundColor Black

#######################################
## IMPORT MODULES
#######################################
$modulesDir = Join-Path -Path $($env:USERPROFILE) -ChildPath "Documents\WindowsPowerShell\Modules"
$modules = Get-ChildItem -Path $modulesDir -Filter "*.psm1" -Recurse
foreach($module in $modules)
{
    $fileName = [System.IO.Path]::GetFileNameWithoutExtension($module.FullName)
    Write-Host "Importing module: $fileName" -ForegroundColor DarkBlue
    Import-Module -Name $module
}
