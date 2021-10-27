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
    Copy Id and Name to HTML fragment
.PARAMETER copyShortLinkToClipboard
    Copy Id to HTML fragment
.PARAMETER triageHighPriority
.PARAMETER triageHighPriority
.PARAMETER triageLowPriority
.PARAMETER divertToDev
.PARAMETER syncPriorityToDefects
.PARAMETER triageUnshieldedProductDS

.PARAMETER openInBrowser
    Open browser window and navigate to Defect Suite in Rally
.PARAMETER calculateCycleTimes
.PARAMETER getUuid

.EXAMPLE

#>
function Get-DefectSuite {
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
    function getUUID(){
        param(
            [Parameter(ValueFromPipeline)] $dsData
        )
        $dsData.QueryResult.Results[0]._refObjectUUID
    }
    function getName(){
        param(
            [Parameter(ValueFromPipeline)] $dsData
        )
        $dsData.QueryResult.Results[0]._refObjectName
    }

    # Lookup Defect Suite
    if($dsId){
        dsApiResponse($dsId) | getName
    }
    if($openDefectSuite){
        dsApiResponse($dsId) | getName
    }
    if($getUuid){
        dsApiResponse($dsId) | getUUID
    }
    if($copyUrlToClipboard){
        $uuid = dsApiResponse($dsId) | getUUID
        "https://rally1.rallydev.com/#/detail/defectsuite/$uuid"  | clip
    }
    if($openInBrowser){
        $uuid = dsApiResponse($dsId) | getUUID
        Start-Process "https://rally1.rallydev.com/#/detail/defectsuite/$uuid"
    }
    if($copyLongLinkToClipboard){
        $dsData = dsApiResponse($dsId) 
        $linkUrl = "https://rally1.rallydev.com/#/detail/defectsuite/$($dsData | getUUID)"
        $linkText = "${$dsId} - $($dsData | getName )"
        $linkHtml = "
                <html>
                <body>
                <!--StartFragment-->
                <a href='$linkUrl'>$linkText</a>
                <!--EndFragment-->
                </body>
                </html>"
        $linkHtml | clip
    }
    if($copyShortLinkToClipboard){
        $dsData = dsApiResponse($dsId) 
        $linkUrl = "https://rally1.rallydev.com/#/detail/defectsuite/$($dsData | getUUID)"
        $linkHtml = "<html>
                <body>
                <!--StartFragment-->
                <a href='$linkUrl'>$dsId</a>
                <!--EndFragment-->
                </body>
                </html>"
        $linkHtml | clip
    }
    if($triageHighPriority){
        
    }
    if($triageLowPriority){
        
    }
    if($divertToDev){
        
    }
    if($syncPriorityToDefects){

    }
    if($triageUnshieldedProductDS){

    }
    if($help){
        Get-Help rqt
    }
}