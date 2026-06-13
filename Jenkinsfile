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

        stage('Build & Load') {
            steps {
                script {
                    // Get the short Git commit hash dynamically
                    def gitCommit = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
                    def imageName = "local/ci-cd:${gitCommit}"

                    // 1. Build with the unique tag
                    sh "docker build -t ${imageName} ."

                    // 2. Load the unique image into Minikube
                    sh "minikube image load ${imageName}"

                    // 3. Dynamically point Kubernetes to the exact new tag
                    sh "kubectl set image deployment/ci-cd-deployment ci-cd=${imageName}"
                }
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