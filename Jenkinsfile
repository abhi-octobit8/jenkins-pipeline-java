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
                    sh """
                        sonar-scanner -Dsonar.projectKey=java-app -Dsonar.sources=src -Dsonar.host.url=http://localhost:9000 -Dsonar.login=sqp_d2cddd0d5ead387830cae6232e6fba7dd1af5000
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
                    def buildInfo = Artifactory.newBuildInfo()

                    // Define the artifacts to be published
                    def artifactPath = "target/*.jar"  // Replace with the actual path to your artifacts

                    // Publish artifacts to Artifactory
                    server.upload spec: "${artifactPath}", buildInfo: buildInfo
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
