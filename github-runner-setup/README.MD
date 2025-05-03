# RUN THE COMMAND in ops console to setup github runner

## github runner setup
ansible-playbook -i ec2_hosts.ini setup-github-runner.yml
Notes: setup-github-runner.sh is the manual script used to configure each of the EC2 instance before setup the ansible playbook

## cleanup EC2 instances
ansible-playbook -i ec2_hosts.ini cleanup.yml


