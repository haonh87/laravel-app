pipeline {
    
    agent {
        kubernetes {
            defaultContainer 'kaniko'
            yaml """
apiVersion: v1
kind: Pod
metadata:
  name: kaniko
spec:
  hostAliases:
  - ip: "192.168.201.49"
    hostnames:
    - "hub.df.ggg.com.vn"
  containers:
  - name: kaniko
    image: gcr.io/kaniko-project/executor:v1.22.0
    imagePullPolicy: Always
    command:
    - /busybox/cat
    tty: true
    volumeMounts:
      - name: jenkins-docker-cfg
        mountPath: /kaniko/.docker
  volumes:
  - name: jenkins-docker-cfg
    projected:
      sources:
      - secret:
          name: docker-credentials
          items:
            - key: .dockerconfigjson
              path: config.json
"""
        }
    }

    environment {
        HARBOR_REGISTRY = 'hub.df.ggg.com.vn'
        HARBOR_PROJECT = 'laravel-app'
        HARBOR_CREDENTIALS_ID = 'haonguyen87-harbor-id'
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

        // build & push image
        stage('Build with Kaniko') {
            steps {
                container(name: 'kaniko', shell: '/busybox/sh') {
                    withEnv(['PATH+EXTRA=/busybox']) {
                        sh '''
                        /kaniko/executor \
                            --context ${WORKSPACE} \
                            --dockerfile ${WORKSPACE}/Dockerfile \
                            --destination ${HARBOR_REGISTRY}/${HARBOR_PROJECT}/${IMAGE_TAG}:develop-${env.BUILD_NUMBER} \
                            --insecure-registry hub.df.ggg.com.vn \
                            --insecure-pull
                        '''
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