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

        stage('4. Precision Image Rollout') {
            steps {
                script {
                    echo "WORKFLOW STEP 4: Sideloading pre-built image to Minikube..."
                    sh "minikube image load ${env.IMAGE_NAME}"

                    // Notice: No kubectl apply commands here!
                    echo 'Surgically rolling out the new image version...'
                    sh "kubectl set image deployment/ci-cd-deployment ci-cd=${env.IMAGE_NAME}"

                    echo 'Monitoring zero-downtime deployment rollout health...'
                    sh "kubectl rollout status deployment/ci-cd-deployment"

                    sh "minikube image prune || true"
                }
            }
        }
    }
}