Jenkinsfile (Declarative Pipeline)
/* Requires the Docker Pipeline plugin */
pipeline {
    agent { docker { image 'php:8.4.8-alpine3.22' } }
    stages {
        stage('build') {
            steps {
                sh 'php --version'
            }
        }
    }
}