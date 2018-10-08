<#
.SYNOPSIS
    Increments the ModuleVersion property in all user PowerShell Module Manfiests
.DESCRIPTION
    Reads an existing Module Manifest file and increments the ModuleVersion property.
.EXAMPLE
    C:\PS> Step-ModuleVersions
.LINK
    http://semver.org/
.LINK
    New-ModuleManifest
#>
function Step-ModuleVersions()
{
    param(
        [Parameter(Position=0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string]$ModuleName
    )
    $script:UserModules  = @( Get-ChildItem -Recurse -Path "$env:USERPROFILE\Documents\WindowsPowerShell\Modules\*.psm1" -ErrorAction SilentlyContinue -Filter $ModuleName )

    Write-Host "Updating module versions..." -ForegroundColor DarkBlue
    Foreach($module in $UserModules)
    {
        $script:ModulePath = $module.FullName.Replace("$($module.name)", "");
        $script:ManifestPath = $module.FullName.Replace("psm1", "psd1");
        $script:ModuleFullName = $module.FullName;
        $script:ModuleName = $module.Name.Replace(".psm1", "");
        $script:Output = Join-Path -Path $ModulePath -ChildPath "Fingerprint";
        $script:FingerprintPath = Join-Path -Path $Output -ChildPath "Fingerprint.txt";

        Try
        {
            if (Test-Path "$ModulePath\Public")
            {
                $functions = Get-ChildItem "$ModulePath\Public\*.ps1" | Where-Object { $_.name -notmatch 'Tests'} | Select-Object -ExpandProperty basename
                Set-ModuleFunctions -Name $ManifestPath -FunctionsToExport $functions
            }

            Write-Host "Detecting semantic versioning for: " -ForegroundColor Yellow -NoNewline; Write-Host $script:ModuleName -ForegroundColor DarkBlue
            Import-Module $ManifestPath
            $commandList = Get-Command -Module $ModuleName
            $version = $(Get-Module -Name $ModuleName).Version
            Remove-Module $ModuleName

            Write-Host "`tCalculating fingerprint"
            $fingerprint = foreach ($command in $commandList )
            {
                foreach ($parameter in $command.parameters.keys)
                {
                    '{0}:{1}' -f $command.name, $command.parameters[$parameter].Name
                    $command.parameters[$parameter].aliases | Foreach-Object { '{0}:{1}' -f $command.name, $_}
                }
            }

            if (Test-Path $FingerprintPath)
            {
                $oldFingerprint = Get-Content $FingerprintPath
            }
            else
            {
                New-Item -Path $Output -ItemType Directory
                New-Item -Path $FingerprintPath -ItemType File
            }

            $bumpVersionType = 'Patch'
            Write-Host "`tDetecting new features"
            $fingerprint | Where-Object {$_ -notin $oldFingerprint } | % {$bumpVersionType = 'Minor'; "      $_"}
            Write-Host "`tDetecting breaking changes"
            $oldFingerprint | Where-Object {$_ -notin $fingerprint } | % {$bumpVersionType = 'Major'; "      $_"}

            Set-Content -Path $FingerprintPath -Value $fingerprint -Force

            # Bump the module version
            if ($version -lt ([version]'1.0.0'))
            {
                # Still in beta, don't bump major version
                if ($bumpVersionType -eq 'Major')
                {
                    $bumpVersionType = 'Minor'
                }
                else
                {
                    $bumpVersionType = 'Patch'
                }
            }

            Write-Host "`tStepping [$bumpVersionType] version [$version]"
            $version = [version] (Step-ModuleVersion -Path $ManifestPath -By $bumpVersionType)
            Write-Host "`tUsing version: $version"
        }
        Catch
        {
            Write-Error -Message "Failed to import module $($import.fullname): $_"
        }
    }
}