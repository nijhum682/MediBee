$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path $PSScriptRoot -Parent
$manifest = Join-Path $projectRoot '.runtime/processes.json'
if (!(Test-Path -LiteralPath $manifest)) { Write-Host 'No managed MediBee processes.'; return }
$records = Get-Content -LiteralPath $manifest -Raw | ConvertFrom-Json
foreach ($record in $records) {
    $process = Get-Process -Id $record.Pid -ErrorAction SilentlyContinue
    if (!$process) { continue }
    $start = $process.StartTime.ToUniversalTime().ToString('o')
    $info = Get-CimInstance Win32_Process -Filter "ProcessId = $($record.Pid)"
    if ($start -eq $record.Started -and $info.CommandLine.Contains($record.Jar)) {
        Stop-Process -Id $record.Pid
        Write-Host "Stopped $($record.Name)"
    } else { throw "PID $($record.Pid) no longer matches the recorded MediBee process; left untouched." }
}
Remove-Item -LiteralPath $manifest
