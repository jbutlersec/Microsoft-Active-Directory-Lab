LA Lakers AD Lab - PowerShell Scripts

Copy these files to:
C:\LA Lakers AD\Scripts

Recommended run order:
1. 00-setup-folder-and-execution-policy.ps1
2. 01-create-ou-structure.ps1
3. 02-create-security-groups.ps1
4. 03-create-users.ps1
5. 04-assign-group-membership.ps1
6. 05-create-group-nesting.ps1
7. 06-create-shared-folders.ps1
8. 08-access-review-report.ps1

Run 07-offboard-users.ps1 only when you want to test offboarding.

To run the full build:
C:\LA Lakers AD\Scripts\09-run-full-lab-build.ps1

Execution policy command:
Set-ExecutionPolicy RemoteSigned -Scope LocalMachine

Important:
Run PowerShell as Administrator on your Domain Controller.
Make sure your CSV files are in C:\LA Lakers AD\CSV.
