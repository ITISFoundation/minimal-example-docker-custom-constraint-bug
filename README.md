# Requirements / Dependencies:

- AWS account & AWS CLI configured
- Terraform installed
- sshpass installed
- ansible installed


### FYI: docker engine version is set in ./ansible/playbooks/docker/install_docker.yml

### Create environment with Docker Major Version 24 - Bug w.r.t. generic resources present
```
ansible-galaxy collection install community.docker
cd terraform && terraform init && terraform plan
TF_VAR_aws_secret_key=AWS_SECRET_KEY TF_VAR_aws_access_key=AWS_ACCESS_KEY terraform apply -auto-approve
cd ..
make ansible/inventory.ini
sudo ansible-playbook -i ansible/inventory.ini -u ansible ansible/playbooks/minimalexample_dockerversion_24.yml
ssh -i terraform/key_openssh.pem ubuntu@$(cd terraform && terraform output -raw eipmanager1)
docker network create -d overlay --scope swarm test-network
docker service create --network test-network --generic-resource "VRAM=1" --constraint node.labels.gpu==true --name test-service quay.io/centos/centos:stream8 bash -c "env && sleep infinity" # this doesnt work
```

### Create environment with Docker Major Version 20 - Bug w.r.t. generic resources not present
```
ansible-galaxy collection install community.docker
cd terraform && terraform init && terraform plan
TF_VAR_aws_secret_key=AWS_SECRET_KEY TF_VAR_aws_access_key=AWS_ACCESS_KEY terraform apply -auto-approve
cd ..
make ansible/inventory.ini
sudo ansible-playbook -i ansible/inventory.ini -u ansible ansible/playbooks/minimalexample_dockerversion_20.yml
chmod 600 terraform/*.pem
ssh -i terraform/key_openssh.pem ubuntu@$(cd terraform && terraform output -raw eipmanager1)
docker network create -d overlay --scope swarm test-network
docker service create --network test-network --generic-resource "VRAM=1" --constraint node.labels.gpu==true --name test-service quay.io/centos/centos:stream8 bash -c "env && sleep infinity" # this works
```
