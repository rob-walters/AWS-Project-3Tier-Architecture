# AWS - 3 Tier-Architecture Secure 3-Tier Web Application Architecture (ALB, EC2, RDS, VPC)
# 📘 Project 3 – AWS 3-Tier Web Application (Free-Tier Architecture)

## 📌 Overview
This project builds a secure and cost-efficient 3-tier web application on AWS.  
The design separates the web, application, and database layers to improve security, reliability, and scalability while staying within the AWS free tier.

---

## 🎯 Project Goals
- Build a VPC with public and private subnets  
- Deploy a public-facing Application Load Balancer  
- Deploy a private EC2 application server  
- Deploy a private RDS MySQL database  
- Use security groups to restrict traffic between layers  
- Deploy a working app using EC2 user data  

---

# 🏛 Architecture Summary

This project uses a standard AWS 3-tier architecture:

## 1. Web Tier (Public)
- Internet-facing Application Load Balancer  
- Lives in public subnets  
- Accepts inbound HTTP traffic  
- Forwards requests to the private application tier  

## 2. App Tier (Private)
- EC2 instance running a Python web app  
- Lives in private subnets  
- No public IP  
- Only accessible from the ALB  

## 3. Database Tier (Private)
- Amazon RDS (MySQL)  
- Private DB subnets  
- No public access  
- Only accessible from the app tier  

---

# 🌐 VPC & Subnet Design

### VPC  
`10.0.0.0/16`

### Public Subnets
- `10.0.50.0/24`  
- `10.0.51.0/24`  
**Purpose:** Application Load Balancer  
**Routing:** `0.0.0.0/0 → Internet Gateway`

### Private App Subnets
- `10.0.60.0/24`  
- `10.0.61.0/24`  
**Purpose:** EC2 App Server  
**Routing:** No internet route  

### Private DB Subnets
- `10.0.70.0/24`  
- `10.0.71.0/24`  
**Purpose:** RDS MySQL  
**Usage:** DB subnet group  

---

# 🔐 Security Group Model

### web-sg
- Allows HTTP (80) from anywhere  
- Attached to the ALB  

### app-sg
- Allows HTTP (80) only from `web-sg`  
- Attached to the EC2 app server  

### db-sg
- Allows MySQL (3306) only from `app-sg`  
- Attached to RDS  

### Traffic Flow
Internet → web-sg → app-sg → db-sg 
This ensures no tier is directly exposed except the ALB.

---

# 🖥 App Tier – EC2 Setup

The EC2 instance runs a simple Python web server using user data (no internet needed).

### User Data Script

```bash
#!/bin/bash
mkdir -p /var/www/html

cat << 'EOF' > /var/www/html/index.html
<html>
  <head>
    <title>Project 3 – 3-Tier App</title>
  </head>
  <body>
    <h1>Project 3 – App Tier</h1>
    <p>This page is served from an EC2 instance in a private subnet.</p>
    <p>VPC: project3-vpc<br>
       Tier: App<br>
       Status: Running</p>
  </body>
</html>
EOF

cd /var/www/html
nohup python3 -m http.server 80 &
###

---

User → ALB → EC2 (Python app) → (optional) RDS

### Private subnet
No public IP
Only reachable through the ALB

### 🛢 Database Tier (RDS)
MySQL engine
Free-tier instance class
20GB storage
Public access disabled
Private DB subnets
Only accessible from app-sg

###  🌍 Web Tier (Application Load Balancer)
Internet-facing
Deployed across public subnets
Uses web-sg
Listener: HTTP 80
Target group: project3-tg
Target: EC2 app instance
Request Flow:
User → ALB → EC2 (Python app) → (optional) RDS

###  🧪 Testing the Architecture
When visiting the ALB DNS URL, the following page loads:
Project 3 – App Tier
This page is served from an EC2 instance in a private subnet.
Status: Running
This confirms:
ALB is working
EC2 web server is running
Private subnets configured correctly
Security groups correctly applied

###  🧱 Why This Architecture Matters
Security
Private EC2
Private RDS
Only ALB exposed publicly
Layer-by-layer security
Scalability
ALB supports Auto Scaling
Easy to add more app servers
Cost-Efficient
All free-tier services
No NAT Gateway
Python server requires no internet access
Industry Standard
This layout matches real production architectures.

###  📈 Future Improvements

Add HTTPS with ACM
Add NAT gateway for SSM & updates
Add Auto Scaling Groups
Add CloudWatch alarms
Add IaC (Terraform/CloudFormation)
Add CI/CD Pipeline

###  🤝 Summary

This project demonstrates AWS 3-tier architecture using:
VPC
Public & private subnets
Security groups
Application Load Balancer
Private EC2
Private RDS

All resources are secured, working, and within the AWS free tier.



