<#
.SYNOPSIS
    Create a new templated module
.DESCRIPTION
    This function creates a new module, several directories, and help documentation with default values.
.PARAMETER ModuleName
    The name of the new module
.EXAMPLE
    C:\PS> New-TemplateModule
.OUTPUTS
    Directories and files    
.NOTES
    Author:         Casey Crouse
    Created On:     10/07/2018
#>
function New-TemplateModule()
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, Position = 0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string]$ModuleName
    )

    Return "Missing implementation"
}
