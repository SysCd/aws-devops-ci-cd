# AWS DevOps CI/CD Pipeline

## Overview

This project demonstrates a CI/CD pipeline for AWS deployments. Below is a custom-made, redesigned diagram of the DevOps workflow, specifically tailored for this project:

![DevOps Diagram](./images/devops.png)  
_Caption: Illustrates the flow from code commits to deployment on AWS EC2 instances._

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
_Caption: High-level flow of the AWS DevOps CI/CD project, from design to individual files._

### File Structure Breakdown

![File Structure Diagram](./images/files.png)  
_Caption: Visual representation of what each file does in the project._

### Regional Architecture

![AWS Az Diagram](./images/Az.png)  
_Caption: Shows the eu-west-2 region with Availability Zones (eu-west-2a, eu-west-2b, eu-west-2c) and low-latency fiber connectivity._

- **Key Features:**
  - **Region:** `eu-west-2` (London), a geographic area in AWS.
  - **Availability Zones:** `eu-west-2a`, `eu-west-2b`, `eu-west-2c`—isolated locations within the region for high availability.
  - **Connectivity:** Low-latency fiber links between zones, ensuring fast and reliable communication.
- **Purpose:** Explains how AWS organizes infrastructure across multiple Availability Zones, promoting fault tolerance and scalability for resilient cloud architectures like EKS or VPCs.

### What’s New in This Update

- Updated the architecture diagram (`NewDiagram.png`) to reflect the latest project structure, showing the flow from high-level design to specific Terraform and Kubernetes files.
- Added a new file structure diagram (`files.png`) to illustrate the purpose of each file (e.g., `eks-cluster.tf`, `nginx-deployment.yml`).
- Included a regional architecture diagram (`Az.png`) to highlight the `eu-west-2` region’s multi-AZ setup.
- Helps viewers quickly understand how network, cluster, monitoring, and regional components connect.

### Purpose of These Diagrams

These diagrams provide a clear, step-by-step guide to setting up the AWS DevOps CI/CD project:

- **Architecture Diagram:** Maps the high-level design to detailed file configurations, highlighting key components like VPC, EKS cluster, node groups, and IAM roles.
- **File Structure Diagram:** Breaks down the role of each file, making it easy to see how the project is organized and what each file does.
- **Regional Architecture Diagram:** Visualizes the `eu-west-2` region’s Availability Zones, aiding in multi-AZ deployment planning.

## Terraform Fundamentals

### Structure

![Terracode Diagram](./images/terraformcode.png)  
_Caption: Visual representation of Terraform code structure and file purposes._

- **Files:** Write your infrastructure plan in `.tf` files (like blueprints).
- **Blocks:** Use these main building blocks in your files:

### Core

- **Terraform Block:** Configures Terraform’s settings (e.g., version).
  - Example: `required_version = "1.5.0"` (ensures a compatible version).
- **Provider Block:** Selects the cloud platform to build on.
  - Example: `provider "aws" { region = "us-east-1" }` (chooses AWS and a region).
- **Variable Block:** Defines placeholders for adjustable values.
  - Example: `variable "region" { default = "us-east-1" }` (allows easy updates).
- **Resource Block:** Specifies the cloud resources to create (e.g., networks, servers).
  - Example: `resource "aws_vpc" "my_vpc" { cidr_block = "10.0.0.0/16" }` (creates a network).

### Storage

![Terraform State Diagram](./images/state.png)  
_Caption: Illustrates how Terraform stores and updates the state file using S3 and DynamoDB for synchronization and locking._

- **Backend Block:** Stores the state file in a persistent location (e.g., cloud storage).
  - Example: `backend "s3" { bucket = "my-bucket" }` (saves state in S3).

### Support

- **Depends On:** Ensures resources are built in the correct order.
  - Example: `depends_on = [aws_vpc.my_vpc]` (waits for the network).
- **Tags:** Labels resources for easy identification in the cloud.
  - Example: `tags = { Name = "my-vpc" }` (names the network).

### Terraform Commands

- **`terraform init`:** Prepares Terraform by downloading tools and setting up.
- **`terraform apply`:** Executes the plan to create or update resources.
- **`terraform destroy`:** Removes all resources created by the plan.

## Setup

- **Prerequisites:** Configure AWS credentials as GitHub Secrets (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`).
- **Installation:** Ensure Docker, Terraform, and kubectl are installed locally.
- **Run Locally:**
  - Navigate to the `terraform` directory: `cd terraform`.
  - Initialize Terraform: `terraform init`.
  - Apply configuration: `terraform apply` (type `yes` to confirm).
- **CI/CD:** Workflows (`terraform-ci.yml`, `k8s-deploy.yml`, `docker-push.yml`) trigger on `main` branch pushes; check GitHub Actions for status.

## Footer

© 2025 GitHub, Inc.
