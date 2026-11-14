# MediBee — Smart Hospital Management System

Single-hospital, three-member microservices starter. Java 21, Spring Boot 3.5.7, Spring Cloud 2025.0.0, Thymeleaf and PostgreSQL.

## Applications
| Application | Port | Owner |
| --- | --- | --- |
| Thymeleaf Web App | 8090 | Shared feature ownership |
| API Gateway | 8080 | Member 2 |
| Identity & Staff | 8081 | Member 1 |
| Appointment & Queue | 8082 | Member 2 |
| Patient & Medical | 8083 | Member 3 |

## Run locally (Windows, no database required)
Java 21 required. Run `./mvnw.cmd verify` then `./scripts/start-local.ps1`.
Visit http://localhost:8090 and http://localhost:8090/system.
Stop only project-managed processes with `./scripts/stop-local.ps1`.
If the default ports are occupied, use `./scripts/start-local.ps1 -PortOffset 10000`. This starts the web app at http://localhost:18090 and adjusts all backend/gateway connections together. The launcher checks occupied ports and never stops unrelated applications.
Default local profile intentionally disables JPA/data-source auto-configuration. Health UP in this profile does not verify PostgreSQL.

## PostgreSQL + all applications in Docker
Install/start Docker Desktop. Copy `.env.example` to `.env`, set a local password, then run `docker compose up --build -d`.
Three logical databases are initialized only when the volume is first created. Never use volume deletion to fix configuration if it contains needed data.
Postgres profile uses Hibernate validation; there are no business entities or schemas yet. Add migrations with each domain feature. The local Docker bootstrap shares a DB login; isolated per-service DB users are required before deployment.

## Implemented baseline
Five executable Spring Boot apps; health endpoints; three routed service status APIs; a real server-rendered system health page; responsive sea-green landing page, login/register and fictional doctor-directory UI shells; CI, Docker and API documentation.

## Intentionally pending
Login, registration, JWT, staff approval, assignments, booking, queue, records, prescriptions and AI. Preview form controls are disabled. No demo admin passwords or production security claims. Public web routes are allowlisted; all other web routes are denied. CSRF remains enabled. Backend services currently expose only non-sensitive bootstrap endpoints. Implement service JWT/resource authorization before adding protected APIs. Keep backend ports private in production.

Use `contracts/` for reviewed API definitions and `docs/TEAM.md` for ownership. Main is the stable baseline; create develop from the reviewed baseline, then work in feature branches.
