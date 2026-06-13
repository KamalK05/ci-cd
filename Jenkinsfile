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