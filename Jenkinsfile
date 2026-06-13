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

        stage('Gradle Build & Containerize') {
            steps {
                script {
                    echo 'Building application and generating Docker image via Buildpacks...'
                    // --no-daemon saves memory on your laptop
                    sh './gradlew bootBuildImage --no-daemon'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                // Your existing docker build command
                sh 'docker build -t local/ci-cd:latest .'

                // AUTOMATION: Tell Jenkins to push the image to Minikube automatically
                echo 'Sideloading image into Minikube...'
                sh 'minikube image load local/ci-cd:latest'
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    echo 'Applying configurations to local Kubernetes cluster...'

                    // Verify k8s folder and file exist before running to prevent hard crashes
                    if (fileExists('k8s/deployment.yaml')) {
                        sh 'kubectl apply -f k8s/deployment.yaml'
                        sh 'kubectl rollout restart deployment/ci-cd-deployment'
                    } else {
                        echo '⚠️ WARNING: k8s/deployment.yaml not found! Skipping deployment stage.'
                    }
                }
            }
        }
    }
}