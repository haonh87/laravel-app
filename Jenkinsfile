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
        IMAGE_TAG = "laravel"
        IMAGE_PUSH_DESTINATION="${HARBOR_REGISTRY}/${HARBOR_PROJECT}/${IMAGE_TAG}:${env.BUILD_NUMBER}-develop"
    }

    stages {

        // build & push image
        stage('Build with Kaniko') {
            steps {
                checkout scm
                container(name: 'kaniko', shell: '/busybox/sh') {
                    withEnv(['PATH+EXTRA=/busybox']) {
                        sh '''
                            echo $IMAGE_PUSH_DESTINATION
                            echo $HARBOR_REGISTRY
                            cat /kaniko/.docker/config.json
                        '''

                        sh '''
                            echo "Listing files in context directory:"
                            ls -al $(pwd)
                        '''

                        sh '''#!/busybox/sh
                            /kaniko/executor --context `pwd` --destination $IMAGE_PUSH_DESTINATION --skip-tls-verify-pull --skip-tls-verify
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