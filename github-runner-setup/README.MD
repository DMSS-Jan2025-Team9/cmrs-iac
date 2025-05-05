# Destroy the EC2 instance using terraform
terraform  destroy -target="module.ec2_instances.aws_instance.this[\"cmrs-github-runner-01\"]"   -target="module.ec2_instances.aws_instance.this[\"cmrs-github-runner-02\"]"  -target="module.ec2_instances.aws_ebs_volume.this[\"cmrs-github-runner-01\"]"  -target="module.ec2_instances.aws_ebs_volume.this[\"cmrs-github-runner-02\"]"

# Re-create the EC2 instance using terraform
terraform init
terraform plan  -var-file="terraform.tfvars"
terraform apply -var-file="terraform.tfvars"

# RUN THE COMMAND in ops console to setup github runner

## manually authenticate the ssh key for first time setup before run ansible script
ssh -i ~/.ssh/ssh-cmrs-ops-console.pem ubuntu@18.143.102.248
ssh -i ~/.ssh/ssh-cmrs-ops-console.pem ubuntu@13.215.228.136

# the github self hosted runner setup token will renew
Refer to this url and get the latest token then update in the setup-github-runner.yml
https://github.com/organizations/DMSS-Jan2025-Team9/settings/actions/runners/new?arch=x64&os=linux

## github runner setup
ansible-playbook -i ec2_hosts.ini setup-github-runner.yml
Notes: setup-github-runner.sh is the manual script used to configure each of the EC2 instance before setup the ansible playbook

## cleanup EC2 instances
ansible-playbook -i ec2_hosts.ini cleanup.yml


