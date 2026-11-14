# Team ownership
| Member | Service | UI | Shared duty |
| --- | --- | --- | --- |
| 1 | Identity & Staff | Public, auth, admin staff pages | Security and layout |
| 2 | Appointment & Queue | Booking, check-in, queue | Gateway and CI |
| 3 | Patient & Medical | Patient, vitals, consultation, prescription, AI FAQ | Docker and deployment |

Each service owns its database. Never join across databases or create cross-service JPA relationships. Use UUID references and REST contracts. Doctor schedules belong to Identity; bookable availability belongs to Appointment. Approvals, one-to-one active assistant assignment and clinical authorization are feature work, not implemented in this baseline.

Workflow: feature/* -> reviewed PR -> develop -> reviewed PR -> main. All members own their feature templates and controllers in the shared web app. Do not place real patient data or credentials in Git.
