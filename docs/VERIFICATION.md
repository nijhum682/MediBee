# Local verification

Verified on 2026-11-14 with Java 21 on Windows.

- Maven reactor verify: SUCCESS across five application modules.
- Tests: 8 passed, no failures/errors.
- Running ports: Gateway 18080; Identity 18081; Appointment 18082; Medical 18083; Web 18090.
- All five /actuator/health endpoints returned UP.
- All three status APIs routed through the Gateway returned the correct service identity.
- Landing, login, registration, doctors, system and stylesheet returned HTTP 200.
- Rendered /system page displayed three UP results from real downstream requests.
- Stop script successfully stopped only recorded project processes, followed by a successful restart.

Database/Docker startup was not verified: Docker Desktop engine was unavailable. The current processes use the database-free local profile. Login and business features remain explicit UI previews.

Run again: powershell -NoProfile -ExecutionPolicy Bypass -File scripts/start-local.ps1 -PortOffset 10000
Stop: powershell -NoProfile -ExecutionPolicy Bypass -File scripts/stop-local.ps1
