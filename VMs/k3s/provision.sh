#!/bin/bash

# Atualizar pacotes do sistema
sudo yum update -y

# Instalar utilitários
sudo yum install git unzip telnet net-tools -y

# Baixar e instalar o K3s
curl -sfL https://get.k3s.io | sh -s - --cluster-init --tls-san 192.168.10.2 --node-ip 192.168.10.2 --node-external-ip 192.168.10.2

# Clonar e linkar o kubectx
git clone https://github.com/ahmetb/kubectx /opt/kubectx
ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
ln -s /opt/kubectx/kubens /usr/local/bin/kubens

# Editar o arquivo de registro Jenkins
cat <<EOF > /etc/rancher/k3s/registries.yaml
mirrors:
  docker.io:
    endpoint:
      - "http://192.168.10.5:8123"
configs:
  "192.168.10.5:8123":
    auth:
      username: jenkins
      password: jenkins
EOF

# Reiniciar o serviço K3s
systemctl restart k3s.service

# Validação do cluster K3s
echo "Validando cluster K3s..."
kubectl cluster-info

# Configurar o Docker para usar um registro inseguro
sudo mkdir -p /etc/docker
echo '{
  "insecure-registries": ["192.168.10.5:8123"]
}' | sudo tee /etc/docker/daemon.json
sudo systemctl restart docker

# Criar o secret para o registro Docker no Kubernetes
kubectl create secret docker-registry jenkins \
  --docker-server=192.168.10.5:8123 \
  --docker-username=jenkins \
  --docker-password=jenkins \
  --namespace=devops

# Copiar informações do arquivo k3s.yaml para a área de transferência
echo "Copie para a área de transferência e cole no config no jenkins..."
cat /etc/rancher/k3s/k3s.yaml
