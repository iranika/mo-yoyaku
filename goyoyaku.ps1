param(
    $url = "http://clap.webclap.com/clap.php?id=momoirocode",
    $jsonFile = "$PSScriptRoot\goyoyaku.json"
)

$ErrorActionPreference = "Stop"

$res = (Invoke-WebRequest $url -UseBasicParsing).Links | Where-Object { $_.href -match "https://drive.google.com" }
if ([string]::IsNullOrEmpty($res)){
    Write-Error "Not found Element of a-tag, href match https://drive.google.com"
}
$target = @{}
$target.href = $res.href
$target.text = ([xml]$res.outerHTML).FirstChild.InnerText
$target.timestamp = Get-Date -Format "yyyyMMdd"

$json = Get-Content $jsonFile -Raw | ConvertFrom-Json

if ($target.href -in $json.href){
    Write-Information "Don't need update."
}else{
    $json += $target
}

$json | ConvertTo-Json | Out-File $jsonFile