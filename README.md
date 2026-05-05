AWS WAF Security for API Gateway

This project demonstrates the implementation of AWS Web Application Firewall (WAF) to secure an API Gateway endpoint. It covers both manual configuration (ClickOps) and automated deployment (Terraform).

🛡️ Implementation A: ClickOps The goal was to manually provision a Web ACL to understand the underlying AWS WAF architecture and its integration with API Gateway stages. 
Evidence of Implementation, screenshots of : API Request Allowed (WAF Logging), API Request Blocked (Rule Triggered), WAF Dashboard showing API Gateway association.

🤖 Implementation B: Terraform (Automation) Using Infrastructure as Code, I automated the security layer by integrating a waf.tf module into the existing API Gateway codebase. 

Key Features Added:AWS Managed Rule Sets: Common Rule Set (CRS) and Rate Limit Rule (RLL). 
Association: Automated linking of the Web ACL to the API Gateway ARN.

Verification:Terraform State: Screenshot of terraform state list confirming the new WAF resources. 
AWS Console: Screenshot of the Terraform-managed WAF showing the active managed rule groups. 
