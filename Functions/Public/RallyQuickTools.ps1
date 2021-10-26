# [Nuget in Powershell](https://timatlee.com/post/nuget-in-powershell/)

<#
.SYNOPSIS
    Provides SRE-specific handling of Rally Tickets
.DESCRIPTION
    Manage Default Suites and defects using the following commands
.PARAMETER defectSuite
    Required default Defect Suite id
.PARAMETER copyUrlToClipboard
    Copy the DS URL to the Windows Clipboard for pasting anywhere
.PARAMETER copyLongLinkToClipboard
.PARAMETER copyShortLinkToClipboard

.PARAMETER triageHighPriority
.PARAMETER triageHighPriority
.PARAMETER triageLowPriority
.PARAMETER divertToDev
.PARAMETER syncPriorityToDefects
.PARAMETER triageUnshieldedProductDS

.PARAMETER openInBrowser
.PARAMETER calculateCycleTimes
.PARAMETER getUuid
.EXAMPLE

#>
function rqt {
    param(
        [Parameter(Position=0,Mandatory=$true)]
        [string][alias("ds")] $dsId,
        [switch][alias("cu")] $copyUrlToClipboard,
        [switch][alias("clong")] $copyLongLinkToClipboard,
        [switch][alias("cshort")] $copyShortLinkToClipboard, 
        [switch][alias("thp")] $triageHighPriority,
        [switch][alias("tlp")] $triageLowPriority,
        [switch][alias("dd")] $divertToDev,
        [switch][alias("sync")] $syncPriorityToDefects,
        [switch][alias("tu")] $triageUnshieldedProductDS,
        [switch][alias("web")] $openInBrowser,
        [switch][alias("calc")] $calculateCycleTimes,
        [switch][alias("uuid")] $getUuid,
        [switch][alias("h")] $help
    )
    $hname = "zsessionid"
    $storeParameter = "/SRE/Rally/zsessionid"
    $hvalue = aws ssm get-parameter --name "$storeParameter" --with-decryption --query 'Parameter.Value' --output text
    $dsId = $dsId.ToUpper()
    if(-not $dsId  -match "DS\d{3,5}"){
        return Write-Host "Defect Suite id must match pattern 'DS\d{3,5}"
    }
    $dsUrl = "https://rally1.rallydev.com/#/detail/defectsuite/"
    function dsFullObject($dsNumber){
        Invoke-RestMethod -Uri = "https://rally1.rallydev.com/slm/webservice/v2.0/defectsuite/$dsNumber" 
    } 

    function dsApiResponse($dsId){
        Invoke-RestMethod -Uri "https://rally1.rallydev.com/slm/webservice/v2.0/DefectSuite?query=(FormattedID = $dsId)" -Headers @{$hname=$hvalue} | Select-Object QueryResult 
    }

    # Lookup Defect Suite
    if($dsId){
        dsApiResponse($dsId).QueryResult.Results[0]._refObjectName
    }
    if($openDefectSuite){
        dsApiResponse($dsId).QueryResult.Results[0]._refObjectName
    }
    if($getUuid){
        dsApiResponse($dsId).QueryResult.Results[0]._refObjectUUID
    }
    if($copyUrlToClipboard){
        $uuid = dsApiResponse($dsId).QueryResult.Results[0]._refObjectUUID 
        "https://rally1.rallydev.com/#/detail/defectsuite/$uuid"  | clip
    }
    if($openInBrowser){
        $uuid = dsApiResponse($dsId).QueryResult.Results[0]._refObjectUUID 
        Start-Process "https://rally1.rallydev.com/#/detail/defectsuite/$uuid"
    }
    if($help){
        Get-Help rqt
    }

}
rqt DS2820