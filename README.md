# feed-the-cat project

### Prerequisites:

* Terraform v0.12.20
* AWS CLI

### Setup:
```
terraform init
```
```
terraform apply -var aws_region="your-aws-region" -var email_sender="your-ses-sender-email" -var email_recipient="your-email-to-receive-alarms"
```

<b>IMPORTANT</b>: you'll have to verify your "email_sender" after applying Terraform.

### What can be improved:

* Python code.
* Create Lambda functions on VPC (private subnets) alongside VPCEndpoints to point S3 and DynamoDB using private tunnel (cost optimization + more secured) 
