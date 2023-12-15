pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                // Checkout the source code from your version control system (e.g., Git)
                checkout scm
            }
        }

        stage('Build') {
            steps {
                // Use the Maven tool configured in your Jenkins server
                bat 'mvn clean package'
            }
        }

        stage('Test') {
            steps {
                // Run the unit tests
                bat 'mvn test'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                // Run SonarQube analysis
                withSonarQubeEnv('default-sonar') {
                    bat """
                        mvn clean verify sonar:sonar -Dsonar.projectKey=java-app -Dsonar.projectName='java-app
                    """
                }
            }
        }

        stage('Package') {
            steps {
                // Archive the JAR file for future use (optional)
                archiveArtifacts artifacts: '**/target/*.jar', allowEmptyArchive: true
            }
        }

       stage('Publish to Artifactory') {
            steps {
                script {
                    def server = Artifactory.server 'Artifactory-1'
                    def uploadSpec = '''{
                        "files": [
                            {
                                "pattern": "target/*.jar",
                                "target": "java-app"
                            }
                        ]
                    }'''

                    def buildInfo = Artifactory.newBuildInfo()
                    
                    // Publish artifacts to Artifactory
                    server.upload(uploadSpec, buildInfo)
                }
            }
        }

        stage('Docker Build') {
            steps {
                script {
                    // Define the Docker image name and tag
                    def dockerImage = 'your-docker-image-name:tag'
                    
                    // Build the Docker image using the specified Dockerfile
                    sh "docker build -t $dockerImage -f Dockerfile ."
                }
            }
        }

        stage('Docker Push') {
            steps {
                script {
                    // Specify your Docker image name and tag
                    def dockerImage = 'your-docker-image-name:tag'
                    
                    // Log in to the Docker registry (if needed)
                    withCredentials([usernamePassword(credentialsId: 'your-docker-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh "docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD"
                    }
                    
                    // Push the Docker image to a container registry
                    sh "docker push $dockerImage"
                }
            }
        }

        stage('Initialize Terraform') {
            steps {
                // Initialize Terraform in your working directory
                bat 'terraform init'
            }
        }

        stage('Plan Terraform Changes') {
            steps {
                // Create an execution plan to review changes
                bat 'terraform plan -out=tfplan'
            }
        }

        stage('Apply Terraform Changes') {
            steps {
                // Apply the changes to create the AKS cluster
                bat 'terraform apply -auto-approve tfplan'
            }
        }

        stage('Deploy to AKS') {
            steps {
                script {
                    def kubeconfigPath = sh(script: 'echo $KUBECONFIG', returnStdout: true).trim()
                    
                    // Set the image for the deployment
                    sh "kubectl --kubeconfig=$kubeconfigPath set image deployment/your-deployment-name your-container-name=$IMAGE_NAME"
                }
            }
        }

    }

    post {
        success {
            echo 'job successful'
        }

        failure {
            echo 'job failed'
        }
    }
}
