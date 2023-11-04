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
                sh 'mvn clean package'
            }
        }

        stage('Test') {
            steps {
                // Run the unit tests
                sh 'mvn test'
            }
        }

        stage('Package') {
            steps {
                // Archive the JAR file for future use (optional)
                archiveArtifacts artifacts: '**/target/*.jar', allowEmptyArchive: true
            }
        }
    }

    post {
        success {
            // You can add post-build actions here, e.g., deploying to a server.
            // You can also use the "Mailer" plugin to send email notifications on success.
        }

        failure {
            // You can define actions to be taken on build failure here.
        }
    }
}
