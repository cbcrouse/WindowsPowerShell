Write-Host "CUAH Master Profile loaded." -ForegroundColor Yellow -BackgroundColor Black

#######################################
## IMPORT MODULES
#######################################
$modulesDir = Join-Path -Path $(Get-Location) -ChildPath "Modules"
$modules = Get-ChildItem -Path $modulesDir -Filter "*.psm1" -Recurse
foreach($module in $modules)
{
    $fileName = [System.IO.Path]::GetFileNameWithoutExtension($module)
    Write-Host "Importing module: $fileName" -ForegroundColor DarkBlue
    Import-Module -Name $module
}
