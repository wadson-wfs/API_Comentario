#!/bin/bash

# Atualição dos pacotes do sistema
sudo yum update -y

# Instalação de utilitários
sudo yum install -y wget git net-tools nano

# Baixa o Prometheus
sudo wget https://github.com/prometheus/prometheus/releases/download/v2.45.5/prometheus-2.45.5.linux-amd64.tar.gz
sudo tar xvf prometheus-2.45.5.linux-amd64.tar.gz

# Move os arquivos do Prometheus
sudo mkdir /etc/prometheus
sudo mv prometheus-2.45.5.linux-amd64/* /etc/prometheus

# Criação do usuário prometheus
sudo useradd --no-create-home --shell /bin/false prometheus
sudo chown -R prometheus:prometheus /etc/prometheus

# Criação do arquivo de serviço do Prometheus
cat << EOF | sudo tee /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus Monitoring
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/etc/prometheus/prometheus \\
  --config.file=/etc/prometheus/prometheus.yml \\
  --storage.tsdb.path=/var/lib/prometheus/ \\
  --web.listen-address=0.0.0.0:9090

[Install]
WantedBy=multi-user.target
EOF

# Dá permissão de execução para o binário do Prometheus
sudo chmod +x /etc/prometheus/prometheus

# Inicia e habilita o Prometheus
sudo systemctl daemon-reload
sudo systemctl enable prometheus
sudo systemctl start prometheus

# Configura e instala o Grafana
sudo tee /etc/yum.repos.d/grafana.repo <<EOF
[grafana]
name=Grafana
baseurl=https://packages.grafana.com/oss/rpm
repo_gpgcheck=1
enabled=1
gpgcheck=1
gpgkey=https://packages.grafana.com/gpg.key
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
EOF

# Instalação do Grafana
sudo yum install grafana -y

# Inicia e habilita o Grafana
sudo systemctl enable grafana-server
sudo systemctl start grafana-server