param(
    $url = "http://clap.webclap.com/clap.php?id=momoirocode",
    $jsonFile = "$PSScriptRoot\goyoyaku.json",
    $jsFile = "$PSScriptRoot\goyoyaku.js"
)

$ErrorActionPreference = "Stop"

$res = (Invoke-WebRequest $url -UseBasicParsing).Links | Where-Object { $_.href -match "https://drive.google.com" }
if ([string]::IsNullOrEmpty($res)){
    Write-Error "Not found Element of a-tag, href match https://drive.google.com"
}

$json = Get-Content $jsonFile -Raw | ConvertFrom-Json

if ($res.href -in $json.href){
    Write-Information "Don't need update."
}else{
    $target = @{}
    $target.href = $res.href
    $target.text = ([xml]$res.outerHTML).FirstChild.InnerText
    $target.timestamp = Get-Date -Format "yyyyMMdd"    
    $json += $target
}

$json | ConvertTo-Json | Out-File $jsonFile -Encoding utf8
echo "goyoyaku = " | Out-File $jsFile -Encoding utf8
$json | ConvertTo-Json | Out-File $jsFile -Encoding utf8 -Append
