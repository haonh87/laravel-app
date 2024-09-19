pipeline {
    agent any

    environment {
        HARBOR_REGISTRY = 'hub.df.ggg.com.vn'
        HARBOR_PROJECT = 'laravel-app'
        HARBOR_CREDENTIALS_ID = 'haonguyen87-harbor-id'
        DOCKER_IMAGE = 'hub.df.ggg.com.vn/php-library/php:8.2-fpm'
        GIT_REPO = 'https://github.com/haonh87/laravel-app.git'
        GIT_BRANCH = 'develop'
        ARGOCD_APP = 'laravel-app-develop'
        IMAGE_TAG = "laravel-app"
        JENKINS_GIT_CREDENTIAL_ID='github-haonh87-token-id'
    }

    stages {
        // checkout branch
        stage('Checkout Source') {
            steps {
                git branch: "${env.GIT_BRANCH}", credentialsId: "${env.JENKINS_GIT_CREDENTIAL_ID}", url: "${env.GIT_REPO}"
            }
        }

        // check docker version
        stage('Check docker version') {
            steps {
                script {
                    sh 'docker --version'
                }
            }
        }

        // build docker image
        // push docker image to harbor
        stage('Build docker image & Push image to Harbor') {
            steps {
                script { 
                    docker.withRegistry("http://${HARBOR_REGISTRY}", "${DOCKER_CREDENTIALS_ID}") {
                        def appImage = docker.build("${IMAGE_TAG}:develop-${env.BUILD_NUMBER}", "-f Dockerfile .")
                        appImage.push();
                    }
                }
            }
        }

        // deploy to k8s cluster
        stage('Deploy to K8S via ArgoCD') {
            steps {
                script {
                    sh """
                    argocd app sync ${ARGOCD_APP} --grpc-web
                    """
                }
            }
        }
    }

    post {
        success {
            echo 'Deployment successful!'
        }
        failure {
            echo 'Deployment failed.'
        }
    }
}