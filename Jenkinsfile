pipeline {
    agent any

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Gradle Build & Containerize') {
            steps {
                script {
                    // Give execution permissions to the gradle wrapper inside Jenkins
                    sh 'chmod +x ./gradlew'

                    // Tell Gradle to compile the app and build the Docker image
                    sh './gradlew bootBuildImage --no-daemon'
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Apply your Kubernetes configurations
                    sh 'kubectl apply -f k8s/deployment.yaml'

                    // Force K8s to reload the pod with the fresh image Gradle just built
                    sh 'kubectl rollout restart deployment/ci-cd-deployment'
                }
            }
        }
    }
}