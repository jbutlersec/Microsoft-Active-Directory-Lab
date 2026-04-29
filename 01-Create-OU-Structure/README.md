# Phase 02: Organizational Unit (OU) & Security Group Hierarchy

This phase focuses on the logical architecture of the `lakers.local` domain. By automating the creation of OUs and Security Groups, I have established a scalable framework for Group Policy application and administrative delegation.

### 📜 Featured Script
* **`01-create-ou-structure.ps1`**: A PowerShell orchestration script that programmatically builds the top-level and nested OU structure, ensuring consistency across the environment.

### 🏗️ Hierarchy Design
The structure is designed to support a multi-departmental enterprise:
* **Lakers-Objects:** The root OU for all lab-specific assets.
  * **Departments:** (HR, IT, Sales, Marketing, Finance)
  * **Groups:** Security and Distribution groups for RBAC.
  * **Computers:** Segregated by Workstations and Servers.
  * **Service Accounts:** Dedicated OU for non-human identities.

### 🛡️ Security Implementation
* **Prevention of Accidental Deletion:** All OUs are created with the `ProtectedFromAccidentalDeletion` flag set to `$true`.
* **Standardization:** Using scripts instead of the GUI ensures that naming conventions remain 100% consistent, which is vital for future Group Policy (GPO) targeting.

### 🛠️ Troubleshooting
* **Challenge:** Manually creating 20+ OUs is prone to human error and naming inconsistencies.
* **Solution:** Developed a loop-based PowerShell script to iterate through an array of department names, ensuring a uniform sub-folder structure for every department.