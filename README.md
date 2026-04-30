# 🏛️ Enterprise Active Directory Lab: Identity & Access Management
**Automated Infrastructure Deployment | IAM Lifecycle Orchestration | System Hardening**

This repository serves as a comprehensive technical portfolio documenting the end-to-end architecture of a Windows Server 2019 environment. By utilizing an "Infrastructure as Code" (IaC) mindset, I have automated the deployment of directory services, security groups, and user lifecycles to demonstrate scalable, secure, and resilient IAM practices.

---

## 🛠️ Technical Stack
* **Hypervisor:** Proxmox VE (Enterprise Virtualization)
* **Directory Services:** Microsoft Active Directory (Windows Server 2019)
* **Automation:** PowerShell 5.1 (Advanced Scripting & Orchestration)
* **Networking:** Ubuntu Server (Gateway/Routing), Pi-hole (DNS Sinkhole)
* **Security:** UFW (Uncomplicated Firewall), IAM Auditing, System Hardening
* **Domain:** `lakers.local`

---

## 🚀 Project Architecture
The lab is organized into eight modular phases, reflecting the real-world deployment cycle of an enterprise network.

### **Phase I: Core Infrastructure**
* **[01-Setup-Initial-AD-Structure](./01-Setup-Initial-AD-Structure):** Forest creation, DNS configuration, and base domain controller promotion.
* **[02-Create-OUs-Groups](./02-Create-OUs-Groups):** Design and automated deployment of a scalable Organizational Unit (OU) hierarchy.

### **Phase II: Identity Orchestration**
* **[03-Create-Users](./03-Create-Users):** Bulk user provisioning using PowerShell and CSV source-of-truth data.
* **[04-Assign-Group-Membership](./04-Assign-Group-Membership):** Granular security group mapping and RBAC (Role-Based Access Control) implementation.
* **[05-Create-Group-Nesting](./05-Create-Group-Nesting):** Inheritance of permissions and streamlined access management across a hierarchy.

### **Phase III: Networking & Security Auditing**
* **[06-Create-Shared-Folders](./06-Create-Shared-Folders):** Automating departmental file services and NTFS permission inheritance.
* **[07-Offboard-Users](./07-Offboard-Users):** Process of securely deactivating accounts.
* **[08-Sys-Admin-Audit](./08-Sys-Admin-Audit):** Final validation of IAM controls, password policies, and domain integrity.

---

## 📁 Repository Standards
To maintain professional transparency, every sub-directory includes:
* **Source Code:** Fully commented PowerShell scripts.
* **Documentation:** A dedicated README explaining the "Why" behind the "How."
* **Validation:** Screenshots of the Active Directory Environment in its post-execution state.
* **Retrospective:** Lessons learned and troubleshooting steps for each technical hurdle.

---

## 👨‍💻 Core Competencies
* **IAM Automation:** Reducing administrative overhead through PowerShell.
* **Systems Architecture:** Designing resilient, virtualized Windows/Linux environments.
* **Security Mindset:** Implementing Zero Trust principles and system hardening.

---
**Connect with me:** www.linkedin.com/in/jordanbutler25


