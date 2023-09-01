# Info

This is code to reproduce a bug in docker swarm mode with generic resources. The bug is at least present in docker version 24.x and not present in docker version 20.x, at least when running on this configuration.

For the example, a terraform cloud environment with 3 EC2 machines is created on AWS on demand. One of the machines is a swarm manager, the two others are workers. One of the workers is a GPU machine, with a docker swarm generic resource called "VRAM" (Videocard-RAM) and a docker node label called "gpu". The other worker is a CPU machine, with a docker node label called "cpu".

For reproducibility, ansible is used to provision the machines (starting from a vanilla ubuntu-20.04 AMI).

The bug is discussed in https://github.com/moby/moby/issues/44378 .

## Requirements / Dependencies:

- AWS account created & AWS CLI configured, AWS Access Token and Secret Token available.
- Terraform installed
- sshpass installed
- ansible installed
- j2 installed
- make installed


*FYI: The docker engine version is set in ./ansible/playbooks/docker/install_docker.yml*



### Create environment with Docker Major Version 24 - Bug w.r.t. generic resources present

In this example, a docker service with a specific placement constraint given by docker node labels, and generic resources, on a swarm-scoped docker network, is created. The instantiation of the docker service's container fails.


```
ansible-galaxy collection install community.docker
export TF_VAR_aws_secret_key=AWS_SECRET_KEY
export TF_VAR_aws_access_key=AWS_ACCESS_KEY
cd terraform && terraform init && terraform plan
terraform apply -auto-approve
cd ..
make ansible/inventory.ini
sudo ansible-playbook -i ansible/inventory.ini -u ansible ansible/playbooks/minimalexample_dockerversion_24.yml
ssh -i terraform/key_openssh.pem ubuntu@$(cd terraform && terraform output -raw eipmanager1)
docker network create -d overlay --scope swarm test-network
docker service create --network test-network --generic-resource "VRAM=1" --constraint node.labels.gpu==true --name test-service quay.io/centos/centos:stream8 bash -c "env && sleep infinity" # this doesnt work
```



### Create environment with Docker Major Version 20 - Bug w.r.t. generic resources not present


In this example, a docker service with a specific placement constraint given by docker node labels, and generic resources, on a swarm-scoped docker network, is created. The instantiation of the docker service's container succeeds.

```
ansible-galaxy collection install community.docker
export TF_VAR_aws_secret_key=AWS_SECRET_KEY
export TF_VAR_aws_access_key=AWS_ACCESS_KEY
cd terraform && terraform init && terraform plan
terraform apply -auto-approve
cd ..
make ansible/inventory.ini
sudo ansible-playbook -i ansible/inventory.ini -u ansible ansible/playbooks/minimalexample_dockerversion_20.yml
chmod 600 terraform/*.pem
ssh -i terraform/key_openssh.pem ubuntu@$(cd terraform && terraform output -raw eipmanager1)
docker network create -d overlay --scope swarm test-network
docker service create --network test-network --generic-resource "VRAM=1" --constraint node.labels.gpu==true --name test-service quay.io/centos/centos:stream8 bash -c "env && sleep infinity" # this works
```
