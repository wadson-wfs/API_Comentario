pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'devops/app'
    }
    stages{
        stage('Build da Imagem Docker'){
            steps {
                sh 'docker build -t ${DOCKER_IMAGE} .'
            }
        }
        stage ('Tempo para build do container'){
            steps{
                sh 'sleep 10'
            }
        }
        stage('Subir docker compose para teste'){
            steps {
                sh 'docker-compose up --build -d'
            }
        }
            stage('Sleep para subida de containers'){
            steps{
                sh 'sleep 20'
            }
        }
        stage('Executar SonarQube'){
            steps{
                script{
                    scannerHome = tool 'sonar-scanner';
                }
                withSonarQubeEnv('sonar-server'){
                    sh "${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=API_Comentario -Dsonar.sources=. -Dsonar.host.url=${env.SONAR_HOST_URL} -Dsonar.login=${env.SONAR_AUTH_TOKEN}"
                }
            }
        }
        stage('Teste da aplicação'){
            steps{
                sh 'chmod +x teste-app.sh'
                sh './teste-app.sh'
            }
        }
        stage('Shutdown dos containers de teste'){
            steps{
                sh 'docker-compose down'
            }
        }
        stage('Fazer Upload da Imagem docker para o Nexus'){
            steps{
                script{
                    withCredentials([usernamePassword(credentialsId: 'nexus-user', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD' )]){
                        sh 'docker login -u $USERNAME -p $PASSWORD ${NEXUS_URL}'
                        sh 'docker tag devops/app:latest ${NEXUS_URL}/devops/app'
                        sh 'docker push ${NEXUS_URL}/devops/app'
                    }
                }
            }
        }
        stage('Apply k8s files'){
            steps{
                sh '/usr/local/bin/kubectl apply -f ./k3s/app-deployment.yaml --validate=false'
                sh '/usr/local/bin/kubectl apply -f ./k3s/app-service.yaml --validate=false'
                sh '/usr/local/bin/kubectl apply -f ./k3s/app-ingress.yaml --validate=false'
            }
        }
    }
}