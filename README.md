# TERRAFORM
Terraform code to setup the below mentioned infrastructure in AWS:
1) Launch a instance that serves a static website displaying the "Instance ID, IP address, mac address" of an instance.
2) Launch a instance for setting up "Health Check System"

### To be Updated/Changed:
 - #CHANGE_ME --> must be filled with proper values
 - #UPDATE_ME --> can be updated with appropriate values if needed

### Terraform Commands:
 - terraform init
 - terraform plan
 - terraform apply -auto-approve 
 - terraform destroy
 
### Note:
 - docker-compose.yml to be added to "Health Check System" server (Since, values may vary it is not included to user_data script)

### Output:
Output can be viewed by hitting the Public IPv4 addresss of an instance