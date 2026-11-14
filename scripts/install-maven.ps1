$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path $PSScriptRoot -Parent
$tools = Join-Path $projectRoot '.tools'
New-Item -ItemType Directory -Force -Path $tools | Out-Null
$url = 'https://repo.maven.apache.org/maven2/org/apache/maven/apache-maven/3.9.9/apache-maven-3.9.9-bin.zip'
$zip = Join-Path $tools 'maven.zip'
Invoke-WebRequest $url -OutFile $zip
$expected = (Invoke-RestMethod "$url.sha512").ToString().Trim().Split(' ')[0]
$actual = (Get-FileHash -LiteralPath $zip -Algorithm SHA512).Hash
if ($actual -ne $expected) { throw 'Maven download checksum mismatch.' }
Expand-Archive -LiteralPath $zip -DestinationPath $tools -Force
Remove-Item -LiteralPath $zip
