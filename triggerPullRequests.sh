pipeline {
    agent any
    stages {
        stage('Execute Commands') {
            steps {
                // Replace with your actual commands to be executed
                sh "mkdir testing"
            }
        }

        // Add more stages as needed
    }

    post {
        always {
            // Clean up or post-processing steps can go here
            deleteDir()
        }
    }

}
