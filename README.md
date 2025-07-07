# ci-cd-ynov-scalingo-terraform

This repository contains the Terraform code to deploy a multi-service application using two different strategies: **local Docker containers** and **Scalingo cloud platform**.

## Project Overview

This project is part of a three-repository system:

- [ci-cd-ynov](https://github.com/Arseid/ci-cd-ynov)
- [ci-cd-ynov-back](https://github.com/Arseid/ci-cd-ynov-back)
- **Infrastructure (this repo):** Terraform code for orchestrating deployments.

---

## Deployment Options

### 1. Docker-based Local Deployment

- **Location:** [`docker/`](./docker/)
- **Description:** Deploys all services as Docker containers on your local machine using pre-built images from my DockerHub repository, [arseid/ci-cd-ynov-arseid](https://hub.docker.com/r/arseid/ci-cd-ynov-arseid/tags)
- **Images:** The images correspond to the applications from the two other repositories ([ci-cd-ynov](https://github.com/Arseid/ci-cd-ynov) and [ci-cd-ynov-back](https://github.com/Arseid/ci-cd-ynov-back)), including React, Flask, MySQL, Node.js, and MongoDB, all packaged as Docker images.
- **How it works:** Terraform provisions containers, networks, and sets environment variables for inter-service connectivity.

### 2. Scalingo Cloud Deployment

- **Location:** [`scalingo/`](./scalingo/)
- **Description:** Deploys the application to Scalingo, a Platform-as-a-Service (PaaS).
- **Automation:** The deployment to Scalingo is performed automatically via a CI/CD pipeline.
- **How it works:** Terraform provisions the app, databases, and containers on Scalingo. The pipeline pulls the latest code directly from the respective repositories.

---

## Getting Started

### Prerequisites (for local deployment)

- [Terraform](https://www.terraform.io/downloads.html)
- [Docker](https://www.docker.com/)

### Usage

#### Local Docker Deployment

1. Navigate to the `docker/` directory.
2. Initialize Terraform:
   ```sh
   terraform init
   ```
3. Apply the configuration:
   ```sh
   terraform apply
   ```
4. Access the services on the exposed ports (e.g., React on `localhost:3000`).

#### Scalingo Deployment

- The deployment to Scalingo is handled automatically by the CI/CD pipeline.
