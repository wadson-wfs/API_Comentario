#!/bin/bash

# Atualização do sistema e instalação de ferramentas básicas
yum update -y
yum install epel-release -y
yum install wget git net-tools telnet unzip java-11-openjdk-devel -y

# Instalação do Jenkins
sudo wget --no-check-certificate -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum install jenkins -y
sudo systemctl daemon-reload
sudo systemctl start jenkins

# Configuração do usuário Jenkins
usermod -s /bin/bash jenkins
sudo su - jenkins
mkdir ~/.kube

# Instalação do Docker e Docker Compose
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install docker-ce docker-ce-cli containerd.io -y
sudo systemctl start docker
sudo systemctl enable docker
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
sudo systemctl daemon-reload
sudo systemctl restart docker
sudo usermod -aG docker jenkins

# Instalação do Sonar Scanner
wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.6.2.2472-linux.zip
unzip sonar-scanner-cli-4.6.2.2472-linux.zip -d /opt/
mv /opt/sonar-scanner-4.6.2.2472-linux /opt/sonar-scanner
chown -R jenkins:jenkins /opt/sonar-scanner
echo 'export PATH=$PATH:/opt/sonar-scanner/bin' | sudo tee -a /etc/profile

# Instalação do Node.js
curl -sL https://rpm.nodesource.com/setup_10.x | sudo bash -
sudo yum install nodejs -y

# Configuração do Nexus
docker volume create --name nexus-data
docker run -d -p 8081:8081 -p 8123:8123 --name nexus -v nexus-data:/nexus-data sonatype/nexus3

# Instalação do kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Criação de um arquivo de unidade Systemd para o Nexus
echo "[Unit]" > /etc/systemd/system/nexus.service
echo "Description=Nexus Docker Container" >> /etc/systemd/system/nexus.service
echo "After=docker.service" >> /etc/systemd/system/nexus.service
echo "" >> /etc/systemd/system/nexus.service
echo "[Service]" >> /etc/systemd/system/nexus.service
echo "Type=simple" >> /etc/systemd/system/nexus.service
echo "User=jenkins" >> /etc/systemd/system/nexus.service
echo "ExecStart=/usr/bin/docker run -d -p 8081:8081 -

# Habilitar a inicialização automática de serviços
sudo systemctl enable jenkins
sudo systemctl enable docker
sudo systemctl enable nexus

# Validando a instalação
echo "Validando instalação..."
echo "Serviços instalados:"
systemctl status jenkins docker nexus | grep active
echo "Verificando Sonar Scanner..."
sonar-scanner --version
echo "Verificando kubectl..."
kubectl version

# Finalização
