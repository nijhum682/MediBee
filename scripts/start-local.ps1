param([ValidateRange(0, 50000)][int]$PortOffset = 0)
$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path $PSScriptRoot -Parent
$runtime = Join-Path $projectRoot '.runtime'
New-Item -ItemType Directory -Force -Path $runtime | Out-Null
$modules = @(
    @{ Path='services/identity-staff-service'; Name='identity-staff-service'; Port=8081 },
    @{ Path='services/appointment-queue-service'; Name='appointment-queue-service'; Port=8082 },
    @{ Path='services/patient-medical-service'; Name='patient-medical-service'; Port=8083 },
    @{ Path='api-gateway'; Name='api-gateway'; Port=8080 },
    @{ Path='web-app'; Name='web-app'; Port=8090 }
)
$java = (Get-Command java -ErrorAction Stop).Source
foreach ($module in $modules) { $module.Port += $PortOffset }
# Validate everything before launching any process.
foreach ($module in $modules) {
    $jar = Join-Path $projectRoot "$($module.Path)/target/$($module.Name)-0.1.0-SNAPSHOT.jar"
    if (!(Test-Path -LiteralPath $jar)) { throw "Build first: missing $jar" }
    if (Get-NetTCPConnection -LocalPort $module.Port -State Listen -ErrorAction SilentlyContinue) {
        throw "Port $($module.Port) is occupied. Stop the existing application first."
    }
}
$started = @()
try {
    foreach ($module in $modules) {
        $jar = Join-Path $projectRoot "$($module.Path)/target/$($module.Name)-0.1.0-SNAPSHOT.jar"
        $javaArgs = @('-Xms32m','-Xmx160m','-XX:+UseSerialGC','-XX:MaxMetaspaceSize=128m','-XX:ReservedCodeCacheSize=48m','-jar',"`"$jar`"",'--spring.profiles.active=local','--server.address=127.0.0.1',"--server.port=$($module.Port)")
        if ($module.Name -eq 'api-gateway') {
            $routeNames = @('identity','appointments','medical')
            for ($index=0; $index -lt 3; $index++) {
                # Spring list properties replace the entire configured list when overridden.
                $javaArgs += "--spring.cloud.gateway.server.webmvc.routes[$index].id=$($routeNames[$index])"
                $javaArgs += "--spring.cloud.gateway.server.webmvc.routes[$index].uri=http://127.0.0.1:$($modules[$index].Port)"
                $javaArgs += "--spring.cloud.gateway.server.webmvc.routes[$index].predicates[0]=Path=/api/v1/$($routeNames[$index])/**"
            }
        }
        if ($module.Name -eq 'web-app') { $javaArgs += "--medibee.gateway-url=http://127.0.0.1:$($modules[3].Port)" }
        $process = Start-Process -FilePath $java -ArgumentList $javaArgs -WindowStyle Hidden -WorkingDirectory $projectRoot -RedirectStandardOutput (Join-Path $runtime "$($module.Name).out.log") -RedirectStandardError (Join-Path $runtime "$($module.Name).err.log") -PassThru
        $record = @{ Name=$module.Name; Pid=$process.Id; Started=$process.StartTime.ToUniversalTime().ToString('o'); Jar=$jar }
        $started += $record
        $started | ConvertTo-Json -Depth 3 | Set-Content (Join-Path $runtime 'processes.json')
    }
    foreach ($module in $modules) {
        $healthy = $false
        for ($attempt=0; $attempt -lt 45; $attempt++) {
            try {
                $health = Invoke-RestMethod "http://127.0.0.1:$($module.Port)/actuator/health" -TimeoutSec 2
                if ($health.status -eq 'UP') { $healthy=$true; break }
            } catch { }
            Start-Sleep -Seconds 1
        }
        if (!$healthy) { throw "$($module.Name) failed readiness. See .runtime logs." }
        Write-Host "$($module.Name): UP on $($module.Port)"
    }
    Write-Host "MediBee: http://localhost:$($modules[4].Port) | Live service checks: http://localhost:$($modules[4].Port)/system"
} catch {
    & (Join-Path $PSScriptRoot 'stop-local.ps1')
    throw
}
