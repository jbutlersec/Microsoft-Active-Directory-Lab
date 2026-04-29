Phase 08: Automated IAM Auditing & Access Review Reporting
This final phase of the lakers.local lab focuses on governance and compliance. To ensure the integrity of the identity environment, I developed a PowerShell auditing script that generates a comprehensive Access Review Report. This tool allows administrators to perform periodic user access reviews, a critical requirement for modern security frameworks.

📜 Featured Script
08-access-review-report.ps1: A sophisticated reporting tool that aggregates deep-level user attributes and group memberships into a centralized audit file.

⚙️ Technical Logic
Advanced Attribute Retrieval: The script queries Active Directory for specific high-value properties including Department, Job Title, Account Status (Enabled/Disabled), and Description.

Dynamic Group Resolution: It iterates through each user's MemberOf attribute, resolving Distinguished Names (DNs) into human-readable group names for easier analysis.

Custom Object Construction: Utilizes [PSCustomObject] to structure disparate data points into a clean, unified record for every identity in the domain.

Automated File Management: Includes logic to automatically detect and create the necessary reporting directories if they do not already exist.

🛡️ Governance & Compliance Standards
Audit-Ready Documentation: By exporting data to a standardized CSV, the script provides a "Point-in-Time" snapshot of the domain's security posture.

Identity Integrity: Highlighting the "Description" field allows auditors to see the automated offboarding stamps (from Phase 07), proving that the lifecycle process is working correctly.

Security Visibility: Centralizing group memberships makes it easy to identify "Permission Creep" or users who may have excessive access beyond their current job function.

🛠️ Troubleshooting & Lessons Learned
Challenge: Raw Active Directory data for group memberships is exported as long, complex strings (Distinguished Names) that are difficult for non-technical auditors to read.

Solution: Implemented a foreach loop within the reporting block to translate those complex strings into simple Group Names, joined by semi-colons for a clean spreadsheet view.

Lesson: Systems Administration is not just about building infrastructure; it is about maintaining visibility. Automated reporting is the bridge between technical execution and security compliance.