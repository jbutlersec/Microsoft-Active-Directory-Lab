Phase 07: Automated User Offboarding & Identity Lifecycle De-provisioning
This phase focuses on the "Termination" or "Offboarding" stage of the IAM lifecycle. To prevent "orphan accounts" and mitigate security risks, I developed a PowerShell orchestration script that automates the multi-step process of de-provisioning user access and securing their identity objects within the lakers.local domain.

📜 Featured Script
07-offboard-users.ps1: A high-security script that automates account disabling, group removal, and organizational migration.

⚙️ Technical Logic
Pre-Execution Check: Verifies the existence of the "Offboarded" Organizational Unit (OU) before processing any requests to ensure object integrity.

Membership Scrubbing: Automatically iterates through a user's MemberOf property to strip all security group memberships, ensuring no residual permissions remain.

Security Hardening: Executes Disable-ADAccount to immediately terminate the user's ability to authenticate.

Administrative Audit Trail: Updates the user's AD Description attribute with a standardized stamp including the Ticket Number, Reason, and Timestamp for future forensic or administrative review.

Object Relocation: Moves the user object to a dedicated "Offboarded" OU, separating inactive identities from the production environment.

🛡️ IAM Security Standards
Risk Mitigation: Automated offboarding ensures that no steps (like group removal) are missed, which is a common source of security vulnerabilities in manual environments.

Standardized Documentation: By requiring a Ticket Number and Reason in the source CSV, this process ensures that every account deactivation is tied to an authorized request.

Compliance Ready: This automated workflow provides the clear, consistent audit trail required by most modern security frameworks (such as SOC2 or HIPAA).

🛠️ Troubleshooting & Lessons Learned
Challenge: Users often remain members of several complex group hierarchies, making manual removal time-consuming and error-prone.

Solution: Utilized a foreach loop to dynamically target and remove every group listed in the user's profile attributes automatically.

Lesson: In a production environment, the "Offboarded" OU should be created during the initial forest setup to ensure de-provisioning scripts never fail due to a missing target path.