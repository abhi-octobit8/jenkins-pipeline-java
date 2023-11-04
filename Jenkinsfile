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

                    // Define the source and target paths for publishing
                    def sourcePath = "target/*.jar"  // Replace with the actual path to your artifacts
                    def targetRepository = 'java-app'  // Replace with the target repository name

                    // Publish artifacts to Artifactory
                    server.upload spec: sourcePath, target: targetRepository
                }
            }
        }

        stage ('Publish build info') {
            steps {
                rtPublishBuildInfo (
                    serverId: "Artifactory-1"
                )
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
