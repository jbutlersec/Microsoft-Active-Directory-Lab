Phase 04: Automated Group Membership & RBAC Implementation
This phase focuses on the orchestration of user-to-group assignments. By automating memberships via PowerShell, I have implemented a scalable Role-Based Access Control (RBAC) model for the lakers.local domain, ensuring users automatically receive the permissions required for their specific job functions.

📜 Featured Script
04-assign-group-membership.ps1: A high-efficiency script that reads a mapping CSV to link user identities with their respective security groups.

⚙️ Technical Logic
Object Validation: The script performs dual-validation checks using Get-ADUser and Get-ADGroup before attempting any modifications to ensure both the identity and the target container exist.

Intelligent Error Handling: Uses a try/catch block to handle common AD errors gracefully, specifically detecting if a user is already a member of a group to avoid unnecessary terminal noise.

Bulk Processing: Designed to process hundreds of memberships in seconds, significantly reducing the manual overhead typically associated with onboarding or departmental transfers.

🛡️ IAM Security Best Practices
Consistency: Ensures that users in the same department (e.g., HR, IT) are assigned to the exact same security groups every time, preventing "permission creep."

Audit-Ready: The console output provides a real-time log of successes and warnings, which can be piped to a text file for administrative auditing.

Least Privilege: By automating these assignments from a verified CSV, I maintain strict control over group memberships, ensuring users only occupy the groups defined by the business logic.

🛠️ Troubleshooting & Lessons Learned
Challenge: Standard Add-ADGroupMember commands throw a terminating error if a user is already in a group, which can halt bulk scripts.

Solution: Implemented specialized exception handling that identifies the "already a member" message and converts it into a non-terminating information notification.

Lesson: When working with identity data, always .Trim() your CSV inputs. Leading or trailing spaces in a spreadsheet are a common cause of "Object Not Found" errors in Active Directory.