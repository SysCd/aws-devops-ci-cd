# AWS DevOps CI/CD Pipeline

## Overview

This project demonstrates a CI/CD pipeline for AWS deployments. Below is a custom-made, redesigned diagram of the DevOps workflow, specifically tailored for this project:

![DevOps Diagram](./images/devops.png)

The diagram illustrates the flow from code commits to deployment on AWS EC2 instances.

## Key Components

- **Version Control**: Git, GitHub
- **Infrastructure as Code**: Terraform
- **Security & Compliance**: IAM, RBAC, Encryption, Policies
- **Containerization & Orchestration**: Docker, Kubernetes EKS
- **CI/CD**: GitHub Actions
- **Monitoring & Logging**: Prometheus, Grafana

## Update 2.0: Enhanced DevOps Project Architecture and File Structure

### Project Architecture Overview

![DevOps Architecture Diagram](./images/NewDiagram.png)  
Caption: High-level flow of the AWS DevOps CI/CD project, from design to individual files.

### File Structure Breakdown

![File Structure Diagram](./images/files.png)  
Caption: Visual representation of what each file does in the project.

### What’s New in This Update

- Updated the architecture diagram (`NewDiagram.png`) to reflect the latest project structure, showing the flow from high-level design to specific Terraform and Kubernetes files.
- Added a new file structure diagram (`files.png`) to illustrate the purpose of each file (e.g., `eks-cluster.tf`, `nginx-deployment.yml`).
- Helps viewers quickly understand how network, cluster, and monitoring components connect.

### Purpose of These Diagrams

These diagrams provide a clear, step-by-step guide to setting up the AWS DevOps CI/CD project:

- **Architecture Diagram:** Maps the high-level design to detailed file configurations, highlighting key components like VPC, EKS cluster, node groups, and IAM roles.
- **File Structure Diagram:** Breaks down the role of each file, making it easy to see how the project is organized and what each file does.

Note: Both images are located in the `/images` folder for a complete overview of the project setup. Explore them to see how the infrastructure and application deployment come together!

### Why It Matters

These visuals make it easy for anyone—whether an interviewer or a collaborator—to grasp the project’s structure and flow. They showcase the setup of a cost-effective EKS cluster with monitoring, ready for deployment.
