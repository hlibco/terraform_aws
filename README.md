# Terraforming


## AWS Credentials
1. `touch ~/.aws/credentials`
2. `vi ~/.aws/credentials`
3. Add the following content to the credentials file created:

*Note:* DO NOT change the credentials path. See(./aws.tf)

```
[terraform]
aws_access_key_id = YOUR_AWS_ACCESS_KEY_ID
aws_secret_access_key = YOUR_AWS_SECRET_ACCESS_KEY
```
You can change *terraform* to the name/alias of your project or *default*.


## SSH Key

Create an SSH key for the *terraform* user.

`ssh-keygen -t rsa -b 4096 -C "email@email.com"`

Save it at `~/.aws/terraform`


## Server Certificate

Create a self-signed certificate for test purposes:
```
sudo openssl genrsa -des3 -passout pass:x -out /etc/ssl/certs/server.pass.key 2048

sudo openssl rsa -passin pass:x -in /etc/ssl/certs/server.pass.key -out /etc/ssl/certs/server.key

sudo rm -f /etc/ssl/certs/server.pass.key

sudo openssl req -new -key /etc/ssl/certs/server.key -out /etc/ssl/certs/server.csr

sudo openssl x509 -req -sha256 -days 365 -in /etc/ssl/certs/server.csr -signkey /etc/ssl/certs/server.key -out /etc/ssl/certs/server.crt
```


---

## Running

### Update modules
`terraform get`

### Plan
To see execution plan.
`terraform plan`

### Apply
To apply the execution plan.
`terraform apply`

### Show
To see the resources created.
`terraform show`

### Destroy
To destroy the resources created.
`terraform destroy`

---
### Reference
https://www.terraform.io/docs/providers/aws/index.html

---

Inspired by:
- https://github.com/segmentio/stack
- https://github.com/xacaxulu/terraform_aws
- https://github.com/nickcharlton/terraform-aws-vpc
- https://github.com/hashicorp/terraform/blob/master/examples/aws-asg/main.tf

RESEARCH:
aws_autoscaling_group > default_cooldown
aws_alb

---

#### AWS Free Tier
https://aws.amazon.com/pt/free/
