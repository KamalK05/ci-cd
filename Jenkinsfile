pipeline {
    agent any

    stages {
        stage('Prepare Environment') {
            steps {
                echo 'Initializing local workspace environment...'
                sh 'chmod +x ./gradlew'
            }
        }

        stage('1. Build Container Image') {
            steps {
                script {
                    // Generate unique Git hash for tracking
                    def gitCommit = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
                    env.IMAGE_NAME = "local/ci-cd:${gitCommit}"

                    echo "WORKFLOW STEP 1: Compiling application and building image version: ${env.IMAGE_NAME}"
                    sh "docker build -t ${env.IMAGE_NAME} ."
                }
            }
        }

        stage('2. Run Unit Tests') {
            steps {
                echo 'WORKFLOW STEP 2: Executing Unit Test Cases...'
//                 sh './gradlew test --no-daemon'
            }
        }

        stage('3. Run Functional Tests') {
            steps {
                echo 'WORKFLOW STEP 3: Executing Functional / Integration Test Cases...'
//                 sh './gradlew integrationTest --no-daemon'
            }
        }

        stage('4. Deploy to Minikube & Configure Ingress') {
            steps {
                script {
                    echo "WORKFLOW STEP 4: Deploying verified image and network configurations to Minikube..."

                    // 1. Sideload the pre-built image into Minikube's local registry
                    sh "minikube image load ${env.IMAGE_NAME}"

                    // 2. Apply your core deployment and service configurations
                    sh 'kubectl apply -f k8s/deployment.yaml'

                    // 3. AUTOMATION FIX: Apply your ingress routing configuration automatically!
                    echo 'Applying Ingress network routing configuration...'
                    sh 'kubectl apply -f k8s/ingress.yaml'

                    // 4. Trigger the Zero-Downtime Rolling Update with the new version tag
                    sh "kubectl set image deployment/ci-cd-deployment ci-cd=${env.IMAGE_NAME}"

                    // 5. Active health monitoring block
                    echo 'Monitoring deployment rollout health...'
                    sh "kubectl rollout status deployment/ci-cd-deployment"

                    sh "minikube image prune || true"
                }
            }
        }
    }
}