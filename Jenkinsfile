pipeline {
    agent any

    stages {
        stage('Prepare Environment') {
            steps {
                echo 'Initializing local workspace environment...'
                // Give execution permissions to the gradle wrapper inside the cloned workspace
                sh 'chmod +x ./gradlew'
            }
        }

        stage('Build & Deploy to Minikube') {
            steps {
                script {
                    // 1. Get the unique short Git commit hash dynamically
                    def gitCommit = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
                    def imageName = "local/ci-cd:${gitCommit}"

                    echo "Building application version: ${imageName}"

                    // 2. Build the Docker image with your unique tag
                    sh "docker build -t ${imageName} ."

                    // 3. Sideload the unique image directly into Minikube's registry
                    echo 'Loading image into Minikube...'
                    sh "minikube image load ${imageName}"

                    // 4. FIX: Ensure the base infrastructure/deployment exists in Minikube first!
                    echo 'Applying deployment configurations...'
                    sh 'kubectl apply -f deployment.yaml'

                    // 5. Update the live deployment inside Minikube to use this exact new tag
                    echo 'Updating Kubernetes deployment image tag...'
                    sh "kubectl set image deployment/ci-cd-deployment ci-cd=${imageName}"

                    // 6. Clean up old unused images inside minikube to keep your laptop storage light
                    sh "minikube image prune || true"
                }
            }
        }
    }
}