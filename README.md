# Considerações Gerais
Ter instalado no WINDOWS:
- Oracle VM Virtual BOX instalado
- Vagrant
- Visual Studio Code (Todos os arquivos / comandos foram criados/executados pelo terminal)

# Sonarqube - Instalação
1. Acessar a pasta `\VMs\sonar`
2. Executar: `vagrant up`

# Sonarqube - Primeiro Acesso
1. Acesse: http://localhost:9000
usuário: admin
senha: admin
* Alterar a senha após o primeiro acesso

# Sonarqube - Criar Token
1. Acesse "My Account"
2. Vá para "Security"
3. Clique em "Generation Token"
4. Nomeie o token como `"sonar-token"`
5. Copie o token gerado

# Sonarqube - Criar Projetos
1. Vá para "Projects".
2. Clique em "Create Project"
3. Escolha "Manual"
4. Defina "Project display name" como `"API_Comentario"`
5. Defina "Project key" como `"API_Comentario"`

# Kubernets - Instalação
1. Acessar a pasta `VMs\k3s`
2. Executar: `vagrant up`

# Jenkins - Instalação
1. Acessar a pasta `VMs\JenkinsNexus`
2. Executar: `vagrant up`

# Jenkins - Configurar o kubectl no Jenkins
1. Acesse o manager (MV do k3s) e execute `cat /etc/rancher/k3s/k3s.yaml`
2. Acesse o Jenkins e edite o arquivo de configuração colando o conteúdo copiado
vi ~/.kube/config

# Jenkins - Primeiro Acesso
1. Acesse o Jenkins via SSH
2. Copie a senha do administrador:
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
3. Acesse o Jenkins em `http://localhost:8080` e cole a senha
4. Instale as extensões sugeridas
5. Crie o primeiro usuário admin:
- Nome do usuário: `jenkins`
- Senha: `jenkins`
- Nome completo: `jenkins`
- Endereço de e-mail: `jenkins@jenkins.com.br`
6. Configuração da Instância
- Mantenha o endereço: http://localhost:8080

# Jenkins - Criar Pipeline
1. Crie um novo trabalho
2. Escolha "Pipeline"
3. Nome: `API_Comentario`.
4. Definition: "Pipeline script"
5. SCM: "Git"
6. Repositório: `https://github.com/wadson-wfs/API_Comentario.git`
7. Credentials: "Add" / "Jenkins"
- Domain: "Global Credentials"
- Kind: "Username with password"
- Username: "seu usuário"
- Password: "token do git"
- Add
8. Branch: `*/master`
9. Script Path: `Jenkinsfile`

# Jenkins - Instalar Extensão do Sonarqube
1. Vá para "Gerenciar Jenkins".
2. "Plugins".
3. "Extensões Disponíveis".
4. Procure e instale "SonarQube Scanner"

# Jenkins - Configurar Servidor do Sonarqube
1. Vá para "Gerenciar Jenkins"
2. "System"
3. "SonarQube servers"
4. Defina:
- Name: `sonar-server`
- Server URL: `http://192.168.10.6:9000`
5. Adicione as Credentials:
- Kind: "secret text"
- Secret: [cole o token do sonar]
- ID: `secret-sonar`

# Jenkins - Configurar Ferramenta do Sonar-Scanner
1. Vá para "Gerenciar Jenkins"
2. "Tools"
3. "SonarQube Scanner"
4. Configure:
- Name: `sonar-scanner`
- SONAR_RUNNER_HOME: `/opt/sonar-scanner`

# Jenkins - Criar Variável do Nexus
1. Vá para "Gerenciar Jenkins"
2. "System"
3. "Propriedades Globais"
4. "Variáveis de Ambiente"
5. Adicione:
- Nome: `NEXUS_URL`
- Valor: `localhost:8123`

# Jenkins - Criar Usuário do Nexus
1. Vá para "Gerenciar Jenkins"
2. "Credentials"
3. "System"
4. "Global credentials (unrestricted)"
5. "Add Credentials"
- Username: `jenkins`
- Password: `jenkins`
- ID: `nexus-user`

# Nexus - Primeiro Acesso
1. Acesse o Jenkins via SSH.
2. Entre no Docker:
docker exec -it nexus bash
3. Execute:
cat /nexus-data/admin.password
copie a senha
4. Acesse `http://localhost:8081` e altere a senha para `nexus`, usuário `admin`
5. Desative "anonymous access"

# Nexus - Criar Usuário Jenkins
1. Vá para "Server Administration"
2. "User"
3. "Create local user"
- ID: `jenkins`
- First name: `jenkins`
- Last name: `jenkins`
- E-mail: `jenkins@jenkins.com.br`
- Password: `jenkins`
- Confirm password: `jenkins`
- Status: "Active"
- Roles: `nx-admin`

# Nexus - Criar Repositório Docker
1. Vá para "Repository" / "Repositories"
2. "Create repository"
3. Escolha "Docker (hosted)"
4. Name: `docker-repo`
5. Marque: "Accept incoming requests"
6. Marque "HTTP": `8123`
7. Clique em "Save"