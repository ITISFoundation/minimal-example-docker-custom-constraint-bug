# Requirements / Dependencies:

- AWS account & AWS CLI configured
- Terraform installed
- sshpass installed
- ansible installed


### Default docke engine version: `docker-ce=5:24.0.5-1~ubuntu.20.04~focal`, set in ./ansible/playbooks/docker/install_docker.yml

```
ansible-galaxy collection install community.docker
cd terraform && terraform init && terraform plan
TF_VAR_aws_secret_key=AWS_SECRET_KEY TF_VAR_aws_access_key=AWS_ACCESS_KEY terraform apply -auto-approve
cd ..
make ansible/inventory.ini
make ansible-provision
ssh -i terraform/key_openssh.pem ubuntu@$(cd terraform && terraform output -raw eipmanager1)
docker network create -d overlay --scope swarm test-network
docker service create --network test-network --generic-resource "VRAM=1" --constraint node.labels.gpu==true --name test-service quay.io/centos/centos:stream8 bash -c "env && sleep infinity"
```
