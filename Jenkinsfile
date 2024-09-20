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
    image: gcr.io/kaniko-project/executor:v1.22.0-debug
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
        ARGOCD_APP = 'laravel-app-develop'
        IMAGE_TAG = "laravel-app"
        IMAGE_PUSH_DESTINATION="${HARBOR_REGISTRY}/${HARBOR_PROJECT}/${IMAGE_TAG}:develop-${env.BUILD_NUMBER}"
    }

    stages {

        // build & push image
        stage('Build with Kaniko') {
            steps {
                echo "${IMAGE_PUSH_DESTINATION}"
                checkout scm
                container(name: 'kaniko', shell: '/busybox/sh') {
                    withEnv(['PATH+EXTRA=/busybox']) {
                        sh '''
                        /kaniko/executor \
                            --context `pwd` \
                            --destination ${IMAGE_PUSH_DESTINATION} \
                            --insecure --insecure-registry hub.df.ggg.com.vn \
                            --insecure-pull
                        '''
                    }
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