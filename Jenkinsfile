pipeline {
    agent any

    environment {
        // Define the Maven installation name if needed
        MAVEN_HOME = tool name: 'maven', type: 'maven'
    }

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

        stage('Package') {
            steps {
                // Archive the JAR file for future use (optional)
                archiveArtifacts artifacts: '**/target/*.jar', allowEmptyArchive: true
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
